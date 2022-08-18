sap.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
       onSelectionChange: function(oEvent) {
            var sNewDeliveryPreferenceCode = oEvent.getParameter("item").getKey();
            var oSegmBtn = oEvent.getSource();
            oSegmBtn.getBindingContext().setProperty("DeliveryPreference_code", sNewDeliveryPreferenceCode);
       }
    };
});
