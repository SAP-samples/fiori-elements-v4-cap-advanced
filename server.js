/*!
 * SAP UI development toolkit for HTML5 (SAPUI5)
        (c) Copyright 2009-2023 SAP SE. All rights reserved 
 */

/**
 * Bootstraps the unified shell in SANDBOX MODE for standalone DEVELOPMENT or DEMO usage scenarios.
 * The renderer is specified in the global Unified Shell configuration object 'window["sap-ushell-config"]'.
 * The configuration object is based on a JSON file that can be given via URL parameter 'sap-ushell-sandbox-config',
 * or, alternatively, can be given at the default file location '/appconfig/fioriSandboxConfig.json'.
 * Note:
 *   - 'applications' provides a simple way to add application links to the sandbox launchpad
 *   - 'services' lets you add catalogues, groups, and IBN navigation tiles to the sandbox launchpad
 * The fiori2 renderer will render the shell header allowing, for instance, testing of additional 
 * application setting buttons.
 * The navigation target resolution service is configured in a way that the empty URL hash is
 * resolved to our own application.
 * The sandbox platform is restricted to development or demo use cases and MUST NOT BE USED
 * FOR PRODUCTIVE SCENARIOS.
 */

const fs = require('node:fs');
const path = require('path');
const cds = require('@sap/cds');

const getJSONFile = (path) => JSON.parse(fs.readFileSync(path));
const getObject = (obj, path) => path.split("/").reduce((node, key) => node?.[key], obj);

let sandbox;

/**
 * Scans for all 'webapp' folders and manifest files stored in folder 'apps'.
 */
scanForAppFolders = (appFolder) => {
    let appFolders = [];
    fs.readdirSync(appFolder, { withFileTypes: true })
        .filter((dirent) => dirent.isDirectory())
        .map((dirent) => dirent.name)
        .forEach((subFolder, depIdx) => {
            if (subFolder !== "." && subFolder !== "..") {
                const dependencyPath = path.resolve(appFolder, subFolder);
                const webappPath = path.join(dependencyPath, "webapp");
                const manifestPath = path.join(webappPath, "manifest.json");
                if (!fs.existsSync(webappPath)) {
                    appFolders = [...appFolders, ...scanForAppFolders(dependencyPath)];
                } else {
                    appFolders.push({
                        subFolder,
                        manifestPath
                    });
                }
            }
        });
    return appFolders;
}

/**
 * Retrieves all app's manfifest settings for entry 'sap.app/crossNavigation/inbounds'.
 */
const getApps = () => {
    const rootDirectory = fs.realpathSync(process.cwd());
    const appDirectory = path.join(rootDirectory, "app");
    const appFolders = scanForAppFolders(appDirectory);
    let apps = {};
    appFolders.forEach((appFolder) => {
        if (fs.existsSync(appFolder.manifestPath)) {
            // console.log(manifestPath);
            const manifestConfig = getJSONFile(appFolder.manifestPath);
            const app = manifestConfig["sap.app"];
            if (app) {
                const inbounds = getObject(manifestConfig, "sap.app/crossNavigation/inbounds") || {};
                const intentKeys = Object.keys(inbounds || {});
                const firstIntent = intentKeys?.[0] || null;
                const firstInbound = inbounds[firstIntent];
                const appId = `${firstInbound.semanticObject}-${firstInbound.action}`;
                const title = firstInbound.title || 'Undefined';
                const description = firstInbound.subTitle || 'Undefined';
                const additionalInformation = `SAPUI5.Component=${app.id}`;
                const applicationType = 'URL';
                const url = `../${appFolder.subFolder}/webapp/`;
                apps[appId] = {
                    title,
                    description,
                    additionalInformation,
                    applicationType,
                    url
                };
            } else {
                Log(`ERROR: Wrong manifest ${appFolder.manifestPath}`);
            }
        }
    })
    return apps;
}

/**
 * One-time event 'bootstrap', emitted immediately after the express.js app
 * has been created and before any middleware or CDS services are added to it.
 */
cds.once('bootstrap', (app) => {
    sandbox = app;
});

/**
 * One-time event 'served', emitted when all services have been bootstrapped
 * and were added to the express.js app.
 */
cds.once('served', () => {

    // Sandbox configuration
    sandbox.get('/appconfig/fioriSandboxConfig.json', (req, res) => {
        const demoConfig = {
            "defaultRenderer": "fiori2",
            "renderers": {
                "fiori2": {
                    "componentData": {
                        "config": {
                            "enablePersonalization": false,
                            "enableUserDefaultParameters": false,
                            "enableHideGroups": false,
                            "enableSetTheme": false,
                            "enableSearch": false,
                            "disableSignOut": true
                        }
                    }
                }
            },
            "applications": getApps(),
            "services": {
                "LaunchPage": {
                    "adapter": {
                        "config": {
                            "catalogs": [],
                            "groups": []
                        }
                    }
                },
                "EndUserFeedback": {
                    "config": {
                        "enabled": false
                    }
                },
                "SupportTicket": {
                    "config": {
                        "enabled": false
                    }
                }
            }
        };

        res.status(200);
        res.send(demoConfig);
    });

    // Sandbox Fiori Launchpad index.html file
    sandbox.get('/sandbox/index.html', (req, res) => {
        res.status(200);
        res.send(`<!DOCTYPE html>
        <html lang="en">
        
        <head>
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>{{appTitle}}</title>
            <style>
                html,
                body,
                body>div,
                #container,
                #container-uiarea {
                    height: 100%;
                }
            </style>
            <script id="sap-ushell-bootstrap" src="https://ui5.sap.com/test-resources/sap/ushell/bootstrap/sandbox.js"></script>
            <script id="sap-ui-bootstrap" src="https://ui5.sap.com/resources/sap-ui-core.js" data-sap-ui-theme="sap_horizon"
                data-sap-ui-compatVersion="edge" data-sap-ui-async="true" data-sap-ui-preload="async"></script>
            <script id="sap-ushell-renderer">
                sap.ui.getCore().attachInit(() => sap.ushell.Container.createRenderer(null, true).then((content) => content.placeAt("content")))
            </script>
        </head>
        
        <body id="content" class="sapUiBody sapUiSizeCompact"></body>
        
        </html>`);
    });
});

// Delegate bootstrapping to built-in server.js of CDS
module.exports = cds.server