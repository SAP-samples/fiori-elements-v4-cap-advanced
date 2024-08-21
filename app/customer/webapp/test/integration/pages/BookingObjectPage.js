sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'sap.fe.cap.customer',
            componentId: 'BookingObjectPage',
            entitySet: 'Booking'
        },
        CustomPageDefinitions
    );
});