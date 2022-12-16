sap.ui.define(
	[
		"sap/ui/core/mvc/ControllerExtension",
	],
	function(ControllerExtension, ) {
		"use strict";
		return ControllerExtension.extend("sap.fe.cap.travel.ext.controller.TravelList", {
			override: {
				routing: {					
					onBeforeNavigation: function(mNavigationParameters) {
						// as long as SAP Fiori elements for OData v4 does not support to configure a different page for
						// creation and detal page we have to add this override which navigates to the detail page
						const oBindingContext = mNavigationParameters.bindingContext;
                        const parameters = {
                            key: /\(([^)]*)\)/.exec(oBindingContext.getPath())[1]
                        };
						this.base.getExtensionAPI().routing.navigateToRoute("TravelObjectPage", parameters)
						return true;
					}
				}
			}
		});
	}
);
