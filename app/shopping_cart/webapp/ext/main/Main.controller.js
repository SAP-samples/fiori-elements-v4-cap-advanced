sap.ui.define(
    [
        'sap/fe/core/PageController'
    ],
    function(PageController) {
        'use strict';

        return PageController.extend('webshop.ext.main.Main', {
            onSelectProduct(event) {
                this.getExtensionAPI().routing.navigate(event.getSource().getBindingContext());
            },
            onSearch(event) {
                var oSource = event.getSource();
                const filters = event.getParameter("filters");
                var oSearchParameters = event.getParameters() || {};
                this.getView().byId("productContainer").getBinding("items").filter(filters).changeParameters({$search:oSearchParameters.search});
            },
            onFiltersChanged(event) {
                const filters = event.getParameter("filters");
                const oSearchParameters = event.getParameter("search");
                this.getView().byId("productContainer").getBinding("items").filter(filters).changeParameters({$search: oSearchParameters})
            },
            onGoToCheckout(event) {
                this.getExtensionAPI().routing.navigateToRoute("CheckoutPage");
            }
        });
    }
);
