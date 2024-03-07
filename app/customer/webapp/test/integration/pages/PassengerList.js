sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'sap.fe.cap.customer',
            componentId: 'PassengerList',
            contextPath: '/Passenger'
        },
        CustomPageDefinitions
    );
});