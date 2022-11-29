# SAP-samples/repository-template
This default template for SAP Samples repositories includes files for README, LICENSE, and .reuse/dep5. All repositories on github.com/SAP-samples will be created based on this template.

# Containing Files

1. The LICENSE file:
In most cases, the license for SAP sample projects is `Apache 2.0`.

2. The .reuse/dep5 file: 
The [Reuse Tool](https://reuse.software/) must be used for your samples project. You can find the .reuse/dep5 in the project initial. Please replace the parts inside the single angle quotation marks < > by the specific information for your repository.

3. The README.md file (this file):
Please edit this file as it is the primary description file for your project. You can find some placeholder titles for sections below.

# Title
Repository with solutions for e-Learning UX405 “Develop an SAP Fiori Elements App Based on a CAP OData V4 Service: Advanced E-learning”.

<!--- Register repository https://api.reuse.software/register, then add REUSE badge:
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/REPO-NAME)](https://api.reuse.software/info/github.com/SAP-samples/REPO-NAME)
-->

## Description
The app is based on https://github.com/SAP-samples/cap-sflight CAP Model with some small adjustments. 
Each branch contains a solution for one of the exercises and is based on the previous exercise. The branch to start with is initial-state-app. 
<!-- Please include SEO-friendly description -->

## Sequence of features(exercises)
### [initial-app-state](https://github.com/SAP-samples/fiori-elements-v4-cap-advanced/tree/initial-app-state) to start the first exercise.
### Exercise 1: Enable the Flexible Column Layout (by using the Application Modeler from the SAP Fiori tools)
Based on branch [initial-app-state](https://github.com/SAP-samples/fiori-elements-v4-cap-advanced/tree/initial-app-state)
Solution branch: [solution/enable-flexible-column-layout](https://github.com/SAP-samples/fiori-elements-v4-cap-advanced/tree/solution/flexible-column-layout)
### Exercise 2: Change the standard UI texts
Based on branch [initial-app-state](https://github.com/SAP-samples/fiori-elements-v4-cap-advanced/tree/initial-app-state)
Solution branch: [solution/change-standard-ui-texts]
### Exercise 3: Enable semantic dates for filter fields of type Date 
Based on [solution/change-standard-ui-texts]
Solution branch: [solution/add-semantic-fields-to-filterbar]
### Exercise 4: Hide a filter bar on the List Report
Based on [solution/add-semantic-fields-to-filterbar]
Solution branch: [solution/hide-filter-bar](https://github.com/SAP-samples/fiori-elements-v4-cap-advanced/tree/solution/hide-filter-bar)
### Exercise 5: Make delete action unavailable for accepted and canceled travels
Based on branch: [solution/add-semantic-fields-to-filterbar]
Solution branch: [solution/make-delete-action-unavailable-for-accepted-travels]
### Exercise 6: Create an action with a mandatory parameter, set a default value for the parameter
Based on branch: [solution/make-delete-action-unavailable-for-accepted-travels]
Solution branch: [solution/create-action-with-a-mandatory-parameter]
### Exercise 7: Add a progress indicator to the table column
Based on branch: [solution/create-action-with-a-mandatory-parameter]
Solution branch: [solution/add-progress-indicator-to-table-column]
### Exercise 8: Add a bullet micro chart to the table column
Based on branch [solution/add-progress-indicator-to-table-column]
Solution branch [solution/add-bullet-micro-chart-to-table]
### Exercise 9: Add a Contact Quick View to a Table
Based on [solution/add-bullet-micro-chart-to-table]
Solution branch: [solution/add-quick-contact-view-to-table]
### Exercise 10 : Create multiple table views on List Report tables – single table mode. 
Based on branch: [solution/add-quick-contact-view-to-table]
Solution branch:  [solution/create-multiple-table-views-single-table-mode]
### Exercise 11 (optional): Create multiple table views on List report tables – multiple table mode
Based on branch: [solution/add-quick-contact-view-to-table]
### Exercise 12:  Put the travel status, total price, and Deduct Discount action into the header area as the most important information
Based on branch:  [solution/create-multiple-table-views-single-table-mode]
Solution branch: [solution/put-travel-status-total-price-deduct-discount-to-header-area-op]
### Exercise 13:  Add the bullet micro chart and the progress indicator to the header area of the Object Page
Based on branch: [solution/put-travel-status-total-price-deduct-discount-to-header-area-op]
Solution branch: [solution/add-bullet-micro-chart-and-progress-indicator-to-op]
### Exercise 14: Add date, multiline text and a placeholder value
Based on [solution/add-bullet-micro-chart-and-progress-indicator-to-op]
Solution branch: [solution/add-date-multiline-text-placeholder]
### Exercise 15: Add Value Help for Dependent Filtering 
Based on [solution/add-date-multiline-text-placeholder]
Solution branch:  [solution/add-value-help-for-dependent-filtering]
### Exercise 16: Hide some additional information on the OP by adding the “Show More” button
Based on [solution/add-value-help-for-dependent-filtering]
Solution branch: [solution/add-show-more-button-on-op]
### Exercise 17: Use Side Effects to update the total price immediately after adding another booking
Based on [solution/add-show-more-button-on-op]
Solution branch:  [solution/use-side-effects-to-update-total-price]
### Exercise 18: Hide Starting Date and End Date for the canceled Travels in the Object Page Section
Based on [solution/use-side-effects-to-update-total-price]
Solution branch: [solution/hide-starting-and-end-dates-for-canceled-travels]
### Exercise 19: Add validation for the field Agency on the Object Page
Based on [solution/hide-starting-and-end-dates-for-canceled-travels]
Solution branch: [solution/add-validation-for-field-agency-on-op]
### Exercise 20: Add a Custom Column to the table on the Object Page 
Based on [solution/add-validation-for-field-agency-on-op]
solution branch: [solution/add-custom-column-to-table-on-op]

## Download and Installation

## Known Issues
<!-- You may simply state "No known issues. -->

## How to obtain support
[Create an issue](https://github.com/SAP-samples/<repository-name>/issues) in this repository if you find a bug or have questions about the content.
 
For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## Contributing
If you wish to contribute code, offer fixes or improvements, please send a pull request. Due to legal reasons, contributors will be asked to accept a DCO when they create the first pull request to this project. This happens in an automated fashion during the submission process. SAP uses [the standard DCO text of the Linux Foundation](https://developercertificate.org/).

## License
Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
