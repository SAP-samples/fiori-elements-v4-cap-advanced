using TravelService from '../../srv/travel-service';
using from '../../db/schema';
using from '../../db/master-data';

//
// annotatios that control the fiori layout
//

annotate TravelService.Travel with @UI: {

    Identification        : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.acceptTravel',
            Label : '{i18n>AcceptTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.rejectTravel',
            Label : '{i18n>RejectTravel}'
        }
    ],
    HeaderInfo            : {
        TypeName      : '{i18n>Travel}',
        TypeNamePlural: '{i18n>Travels}',
        Title         : {
            $Type: 'UI.DataField',
            Value: Description
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: TravelID
        }
    },
    PresentationVariant   : {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : TravelID,
            Descending: true
        }]
    },
    SelectionFields       : [
        to_Agency_AgencyID,
        to_Customer_CustomerID,
        TravelStatus_code,
        BeginDate,
        EndDate
    ],
    LineItem              : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.acceptTravel',
            Label : '{i18n>AcceptTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.rejectTravel',
            Label : '{i18n>RejectTravel}'
        },
        {
            Value            : TravelID,
            ![@UI.Importance]: #High
        },
        {
            Value            : to_Customer_CustomerID,
            ![@UI.Importance]: #High
        },
        {Value: BeginDate},
        {Value: EndDate},
        {Value: BookingFee},
        {Value: TotalPrice},
        {
            $Type            : 'UI.DataField',
            Value            : TravelStatus_code,
            Criticality      : TravelStatus.criticality,
            ![@UI.Importance]: #High
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.deductDiscount',
            Label : '{i18n>DeductDiscount}',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#Progress',
            Label : '{i18n>ProgressOfTravel}',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target: 'to_Agency/@Communication.Contact#contact',
            Label : 'Agency',
        }
    ],
    Facets                : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>GeneralInformation}',
            ID    : 'Travel',
            Facets: [{ // travel details
                $Type : 'UI.ReferenceFacet',
                ID    : 'TravelData',
                Target: '@UI.FieldGroup#TravelData',
                Label : '{i18n>GeneralInformation}'
            }]
        },
        { // booking list
            $Type : 'UI.ReferenceFacet',
            Target: 'to_Booking/@UI.PresentationVariant',
            Label : '{i18n>Bookings}'
        }
    ],
    FieldGroup #TravelData: {Data: [
        {Value: TravelID},
        {Value: to_Agency_AgencyID},
        {Value: to_Customer_CustomerID},
        {Value: Description}
    ]},
    FieldGroup #DateData  : {Data: [
        {
            $Type: 'UI.DataField',
            Value: BeginDate
        },
        {
            $Type: 'UI.DataField',
            Value: EndDate
        }
    ]}
};

annotate TravelService.Booking with @UI: {
    Identification                : [{Value: BookingID}, ],
    HeaderInfo                    : {
        TypeName      : '{i18n>Bookings}',
        TypeNamePlural: '{i18n>Bookings}',
        Title         : {Value: to_Customer.LastName},
        Description   : {Value: BookingID}
    },
    PresentationVariant           : {
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingID,
            Descending: false
        }]
    },
    SelectionFields               : [],
    LineItem                      : [
        {
            Value: to_Carrier.AirlinePicURL,
            Label: '  '
        },
        {Value: BookingID},
        {Value: BookingDate},
        {Value: to_Customer_CustomerID},
        {Value: to_Carrier_AirlineID},
        {
            Value: ConnectionID,
            Label: '{i18n>FlightNumber}'
        },
        {Value: FlightDate},
        {Value: FlightPrice},
        {Value: BookingStatus_code},
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target: '@UI.Chart#TotalSupplPrice',
            Label : '{i18n>Supplements}',
        }
    ],
    Facets                        : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>GeneralInformation}',
            ID    : 'Booking',
            Facets: [
                { // booking details
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'BookingData',
                    Target: '@UI.FieldGroup#GeneralInformation',
                    Label : '{i18n>Booking}'
                },
                { // flight details
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'FlightData',
                    Target: '@UI.FieldGroup#Flight',
                    Label : '{i18n>Flight}'
                }
            ]
        },
        { // supplements list
            $Type : 'UI.ReferenceFacet',
            Target: 'to_BookSupplement/@UI.PresentationVariant',
            Label : '{i18n>BookingSupplements}'
        }
    ],
    FieldGroup #GeneralInformation: {Data: [
        {Value: BookingID},
        {Value: BookingDate, },
        {Value: to_Customer_CustomerID},
        {Value: BookingDate, },
        {Value: BookingStatus_code}
    ]},
    FieldGroup #Flight            : {Data: [
        {Value: to_Carrier_AirlineID},
        {Value: ConnectionID},
        {Value: FlightDate},
        {Value: FlightPrice}
    ]},
};

annotate TravelService.BookingSupplement with @UI: {
    Identification     : [{Value: BookingSupplementID}],
    HeaderInfo         : {
        TypeName      : '{i18n>BookingSupplement}',
        TypeNamePlural: '{i18n>BookingSupplements}',
        Title         : {Value: BookingSupplementID},
        Description   : {Value: BookingSupplementID}
    },
    PresentationVariant: {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingSupplementID,
            Descending: false
        }]
    },
    LineItem           : [
        {Value: BookingSupplementID},
        {
            Value: to_Supplement_SupplementID,
            Label: '{i18n>ProductID}'
        },
        {
            Value: Price,
            Label: '{i18n>ProductPrice}'
        }
    ],
};

annotate TravelService.Flight with @UI: {PresentationVariant #SortOrderPV: { // used in the value help for ConnectionId in Bookings
SortOrder: [{
    Property  : FlightDate,
    Descending: true
}]}};

annotate TravelService.Travel with @(UI.DataPoint #Progress: {
    Value        : Progress,
    Visualization: #Progress,
    TargetValue  : 100,
});

annotate TravelService.Booking with @(
    UI.DataPoint #TotalSupplPrice: {
        Value                 : TotalSupplPrice,
        MinimumValue          : 0,
        MaximumValue          : 120,
        TargetValue           : 100,
        Visualization         : #BulletChart,
        //  Criticality : TotalSupplPrice, // it has precedence over criticalityCalculation => in order to have the criticality color do not use it
        CriticalityCalculation: {
            $Type                 : 'UI.CriticalityCalculationType',
            ImprovementDirection  : #Maximize,
            DeviationRangeLowValue: 20,
            ToleranceRangeLowValue: 75
        }
    },
    UI.Chart #TotalSupplPrice    : {
        ChartType        : #Bullet,
        Title            : 'total supplements',
        AxisScaling      : {$Type: 'UI.ChartAxisScalingType', },
        Measures         : [TotalSupplPrice, ],
        MeasureAttributes: [{
            DataPoint: '@UI.DataPoint#TotalSupplPrice',
            Role     : #Axis1,
            Measure  : TotalSupplPrice,
        }, ],
    }
);

annotate TravelService.TravelAgency with @(Communication.Contact #contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    tel  : [{
        $Type: 'Communication.PhoneNumberType',
        type : #work,
        uri  : PhoneNumber,
    }, ],
    adr  : [{
        $Type   : 'Communication.AddressType',
        type    : #work,
        street  : Street,
        locality: City,
        code    : PostalCode,
        country : CountryCode_code,
    }, ],
});

annotate TravelService.Travel with @(
    UI.SelectionPresentationVariant #tableView : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: ![@UI.PresentationVariant],
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'O',
                }, ],
            }],
        },
        Text               : '{i18n>Open}',
    },
    UI.LineItem #tableView                     : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TravelService.rejectTravel',
            Label : 'rejectTravel',
        },
        {
            $Type: 'UI.DataField',
            Value: Description,
        },
        {
            $Type: 'UI.DataField',
            Value: LastChangedAt,
        },
        {
            $Type: 'UI.DataField',
            Value: TravelID,
        },
        {
            $Type: 'UI.DataField',
            Value: to_Customer_CustomerID,
        },
    ],
    UI.SelectionPresentationVariant #tableView1: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView', ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'A',
                }, ],
            }],
        },
        Text               : '{i18n>Accepted}',
    }
);

annotate TravelService.Travel with @(
    UI.LineItem #tableView1                    : [
        {
            $Type: 'UI.DataField',
            Value: Description,
        },
        {
            $Type: 'UI.DataField',
            Value: LastChangedAt,
        },
        {
            $Type: 'UI.DataField',
            Value: TravelID,
        },
        {
            $Type: 'UI.DataField',
            Value: to_Agency_AgencyID,
        },
        {
            $Type: 'UI.DataField',
            Value: to_Customer_CustomerID,
        },
    ],
    UI.SelectionPresentationVariant #tableView2: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView1', ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'X',
                }, ],
            }],
        },
        Text               : '{i18n>Canceled}',
    }
);
