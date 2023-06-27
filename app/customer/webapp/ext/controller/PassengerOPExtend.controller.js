sap.ui.define(['sap/ui/core/mvc/ControllerExtension',"sap/ui/core/message/Message","sap/ui/core/MessageType", "sap/ui/model/json/JSONModel",
], function (ControllerExtension, Message, MessageType, JSONModel) {
	'use strict';

	return ControllerExtension.extend('sap.fe.cap.customer.ext.controller.PassengerOPExtend', {
		// this section allows to extend lifecycle hooks or hooks provided by Fiori elements
		override: {
			/**
             * Called when a controller is instantiated and its View controls (if available) are already created.
             * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
             * @memberOf sap.fe.cap.customer.ext.controller.PassengerOPExtend
             */
			onInit: function () {
				// you can access the Fiori elements extensionAPI via this.base.getExtensionAPI
				var oModel = this.base.getExtensionAPI().getModel();
			},
			routing: {
				onAfterBinding: async function (oBindingContext) {
					const
						oExtensionAPI = this.base.getExtensionAPI(),
						oModel = oExtensionAPI.getModel(),
						sFunctionName = "getBookingDataOfPassenger",
						oFunction = oModel.bindContext(`/${sFunctionName}(...)`),
						oBookingTableAPI = oExtensionAPI.byId("fe::CustomSubSection::Bookings--OwnBookingsTable"),
						oWarningMessage = new Message({
							type: MessageType.Warning,
							message: await oExtensionAPI.getModel("i18n").getResourceBundle().getText("bookingsNew")
						}),
						oInfoMessage = new Message({
							type: MessageType.Info,
							message: await oExtensionAPI.getModel("i18n").getResourceBundle().getText("bookingsAttention")
						}),
						oPassengerBookingsModel = new JSONModel({
							totalBookingsCount: 0,
							newBookingsCount: 0,
							acceptedBookingsCount: 0,
							cancelledBookingsCount: 0
						});
						this.base.getView().setModel(oPassengerBookingsModel, "passengerBookingsModel");
					// Request OData function with current CustomerID
					const oCustomer = await oBindingContext.requestObject(oBindingContext.getPath());
					oFunction.setParameter("CustomerID", oCustomer.CustomerID);
					await oFunction.execute();
					const oContext = oFunction.getBoundContext();
					oPassengerBookingsModel.setProperty("/totalBookingsCount", oContext.getProperty("TotalBookingsCount"));
					oPassengerBookingsModel.setProperty("/newBookingsCount", oContext.getProperty("NewBookingsCount"));
					oPassengerBookingsModel.setProperty("/acceptedBookingsCount", oContext.getProperty("AcceptedBookingsCount"));
					oPassengerBookingsModel.setProperty("/cancelledBookingsCount", oContext.getProperty("CancelledBookingsCount"));
					if (this.message !== undefined) {
						oBookingTableAPI.removeMessage(this.message);
					}				
					if (oContext.getProperty("NewBookingsCount") > 0) {
						this.message = oBookingTableAPI.addMessage(oWarningMessage);
						oExtensionAPI.showMessages([oInfoMessage]);
					}
				}
			}		
		}
	});
});
