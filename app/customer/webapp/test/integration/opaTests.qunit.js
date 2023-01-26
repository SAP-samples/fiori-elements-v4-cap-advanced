sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'sap/fe/cap/customer/test/integration/FirstJourney',
		'sap/fe/cap/customer/test/integration/pages/PassengerList',
		'sap/fe/cap/customer/test/integration/pages/PassengerObjectPage',
		'sap/fe/cap/customer/test/integration/pages/BookingObjectPage'
    ],
    function(JourneyRunner, opaJourney, PassengerList, PassengerObjectPage, BookingObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('sap/fe/cap/customer') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePassengerList: PassengerList,
					onThePassengerObjectPage: PassengerObjectPage,
					onTheBookingObjectPage: BookingObjectPage
                }
            },
            opaJourney.run
        );
    }
);