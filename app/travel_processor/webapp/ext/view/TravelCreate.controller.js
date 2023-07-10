sap.ui.define(["sap/fe/core/PageController", "sap/m/MessageToast"], function(PageController, MessageToast) {
	"use strict";

	return PageController.extend("sap.fe.cap.travel.ext.view.TravelCreate", {

        reviewTravel: function () {
			this.byId("wizardNavContainer").to(this.byId("reviewPage"));
		},

        createTravel: function () {
            var that = this;
			this.editFlow.saveDocument(this.getView().getBindingContext()).then(function(){
                that.routing.navigateToRoute('TravelList');
            })
		},

        cancelDocument: function () {
            var that = this;
			this.editFlow.cancelDocument(this.getView().getBindingContext()).then(function(){
                that.routing.navigateToRoute('TravelList');
            })
		}
	});
});
