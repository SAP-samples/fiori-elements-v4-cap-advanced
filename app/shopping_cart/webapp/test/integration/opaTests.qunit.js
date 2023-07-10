sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'webshop/test/integration/FirstJourney',
		'webshop/test/integration/pages/ProductsMain'
    ],
    function(JourneyRunner, opaJourney, ProductsMain) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('webshop') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsMain: ProductsMain
                }
            },
            opaJourney.run
        );
    }
);