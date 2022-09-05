using TravelService from '../../srv/travel-service';
using from '../../db/schema';
using from '../../db/master-data';
using from './field-control';

//
// annotatios that control the fiori layout
//

annotate TravelService.Travel with @UI : {

    Identification         : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'TravelService.acceptTravel',
            Label  : '{i18n>AcceptTravel}'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'TravelService.rejectTravel',
            Label  : '{i18n>RejectTravel}'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'TravelService.deductDiscount',
            Label : '{i18n>DeductDiscount}',
        }
    ],
    HeaderInfo             : {
        TypeName       : '{i18n>Travel}',
        TypeNamePlural : '{i18n>Travels}',
        Title          : {
            $Type : 'UI.DataField',
            Value : Description
        },
        Description    : {
            $Type : 'UI.DataField',
            Value : TravelID
        }
    },
    PresentationVariant    : {
        Text           : 'Default',
        Visualizations : ['@UI.LineItem'],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : TravelID,
            Descending : true
        }]
    },
    SelectionFields        : [
        to_Agency_AgencyID,
        to_Customer_CustomerID,
        TravelStatus_code,
        BeginDate,
        EndDate
    ],
    LineItem               : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'TravelService.acceptTravel',
            Label  : '{i18n>AcceptTravel}'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'TravelService.rejectTravel',
            Label  : '{i18n>RejectTravel}'
        },
        {
            Value             : TravelID,
            ![@UI.Importance] : #High
        },
        {
            Value             : to_Customer_CustomerID,
            ![@UI.Importance] : #High
        },
        {Value : BeginDate},
        {Value : EndDate},
        {Value : BookingFee},
        {Value : TotalPrice},
        {
            $Type             : 'UI.DataField',
            Value             : TravelStatus_code,
            Criticality       : TravelStatus.criticality,
            ![@UI.Importance] : #High
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'TravelService.deductDiscount',
            Label  : '{i18n>DeductDiscount}',
        },
        {
            $Type  : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#Progress1',
            Label  : '{i18n>ProgressOfTravel}',
            ![@UI.Hidden]: TravelStatus.createDeleteHidden
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : 'to_Agency/@Communication.Contact#contact',
            Label : 'Agency',
        }
    ],
    Facets                 : [
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>GeneralInformation}',
            ID     : 'Travel',
            Facets : [{ // travel details
                $Type  : 'UI.ReferenceFacet',
                ID     : 'TravelData',
                Target : '@UI.FieldGroup#TravelData',
                Label  : '{i18n>GeneralInformation}',
                ![@UI.PartOfPreview] : false
            }]
        },
        { // booking list
            $Type  : 'UI.ReferenceFacet',
            Target : 'to_Booking/@UI.PresentationVariant',
            Label  : '{i18n>Bookings}'
        }
    ],
    FieldGroup #TravelData : {Data : [
        {Value : TravelID},
        {Value : to_Agency_AgencyID},
        {Value : to_Customer_CustomerID},
        {Value : Description},
        {
            $Type : 'UI.DataField',
            Value : BeginDate,
            ![@UI.Hidden]: TravelStatus.cancelRestrictions
        },
        {
            $Type : 'UI.DataField',
            Value : EndDate,
            ![@UI.Hidden]: TravelStatus.cancelRestrictions
        }
    ]},
    FieldGroup #DateData   : {Data : [
        {
            $Type : 'UI.DataField',
            Value : BeginDate
        },
        {
            $Type : 'UI.DataField',
            Value : EndDate
        }
    ]}
};

annotate TravelService.Booking with @UI : {
    Identification                 : [{Value : BookingID}, ],
    HeaderInfo                     : {
        TypeName       : '{i18n>Bookings}',
        TypeNamePlural : '{i18n>Bookings}',
        Title          : {Value : to_Customer.LastName},
        Description    : {Value : BookingID}
    },
    PresentationVariant            : {
        Visualizations : ['@UI.LineItem'],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : BookingID,
            Descending : false
        }]
    },
    SelectionFields                : [],
    LineItem                       : [
        {
            Value : to_Carrier.AirlinePicURL,
            Label : '  '
        },
        {Value : BookingID},
        {Value : BookingDate},
        {Value : to_Customer_CustomerID},
        {Value : to_Carrier_AirlineID},
        {
            Value : ConnectionID,
            Label : '{i18n>FlightNumber}'
        },
        {Value : FlightDate},
        {Value : FlightPrice},
        {Value : BookingStatus_code},
        {
            $Type  : 'UI.DataFieldForAnnotation',
            Target : '@UI.Chart#TotalSupplPrice',
            Label  : '{i18n>Supplements}',
        }
    ],
    Facets                         : [
        {
            $Type  : 'UI.CollectionFacet',
            Label  : '{i18n>GeneralInformation}',
            ID     : 'Booking',
            Facets : [
                { // booking details
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'BookingData',
                    Target : '@UI.FieldGroup#GeneralInformation',
                    Label  : '{i18n>Booking}'
                },
                { // flight details
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'FlightData',
                    Target : '@UI.FieldGroup#Flight',
                    Label  : '{i18n>Flight}'
                }
            ]
        },
        { // supplements list
            $Type  : 'UI.ReferenceFacet',
            Target : 'to_BookSupplement/@UI.PresentationVariant',
            Label  : '{i18n>BookingSupplements}'
        }
    ],
    FieldGroup #GeneralInformation : {Data : [
        {Value : BookingID},
        {Value : BookingDate, },
        {Value : to_Customer_CustomerID},
        {Value : BookingDate, },
        {Value : BookingStatus_code}
    ]},
    FieldGroup #Flight             : {Data : [
        {Value : to_Carrier_AirlineID},
        {Value : ConnectionID},
        {Value : FlightDate},
        {Value : FlightPrice}
    ]},
};

annotate TravelService.BookingSupplement with @UI : {
    Identification      : [{Value : BookingSupplementID}],
    HeaderInfo          : {
        TypeName       : '{i18n>BookingSupplement}',
        TypeNamePlural : '{i18n>BookingSupplements}',
        Title          : {Value : BookingSupplementID},
        Description    : {Value : BookingSupplementID}
    },
    PresentationVariant : {
        Text           : 'Default',
        Visualizations : ['@UI.LineItem'],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : BookingSupplementID,
            Descending : false
        }]
    },
    LineItem            : [
        {Value : BookingSupplementID},
        {
            Value : to_Supplement_SupplementID,
            Label : '{i18n>ProductID}'
        },
        {
            Value : Price,
            Label : '{i18n>ProductPrice}'
        }
    ],
};

annotate TravelService.Flight with @UI : {PresentationVariant #SortOrderPV : { // used in the value help for ConnectionId in Bookings
SortOrder : [{
    Property   : FlightDate,
    Descending : true
}]}};

annotate TravelService.Travel with @(UI.DataPoint #Progress1 : {
    Value         : Progress,
    Visualization : #Progress,
    TargetValue   : 100,
});

annotate TravelService.Booking with @(
    UI.DataPoint #TotalSupplPrice : {
        Value                  : TotalSupplPrice,
        MinimumValue           : 0,
        MaximumValue           : 120,
        TargetValue            : 100,
        Visualization          : #BulletChart,
        //  Criticality : TotalSupplPrice, // it has precedence over criticalityCalculation => in order to have the criticality color do not use it
        CriticalityCalculation : {
            $Type                  : 'UI.CriticalityCalculationType',
            ImprovementDirection   : #Maximize,
            DeviationRangeLowValue : 20,
            ToleranceRangeLowValue : 75
        }
    },
    UI.Chart #TotalSupplPrice     : {
        ChartType         : #Bullet,
        Title             : 'total supplements',
        AxisScaling       : {$Type : 'UI.ChartAxisScalingType', },
        Measures          : [TotalSupplPrice, ],
        MeasureAttributes : [{
            DataPoint : '@UI.DataPoint#TotalSupplPrice',
            Role      : #Axis1,
            Measure   : TotalSupplPrice,
        }, ],
    }
);
annotate TravelService.TravelAgency with @(
    Communication.Contact #contact : {
        $Type : 'Communication.ContactType',
        fn : Name,
        tel : [
            {
                $Type : 'Communication.PhoneNumberType',
                type : #work,
                uri : PhoneNumber,
            },
        ],
        adr : [
            {
                $Type : 'Communication.AddressType',
                type : #work,
                street : Street,
                locality : City,
                code : PostalCode,
                country : CountryCode_code,
            },
        ],
    }
);

annotate TravelService.Travel with @UI : {
     SelectionVariant#canceled  : {
         $Type : 'UI.SelectionVariantType',
         ID : 'canceled',
         Text : 'canceled',
         Parameters : [
             
         ],
         FilterExpression : '',
         SelectOptions : [
             {
                 $Type : 'UI.SelectOptionType',
                 PropertyName : TravelStatus_code,
                 Ranges : [
                     {
                         $Type : 'UI.SelectionRangeType',
                         Sign : #I,
                         Option : #EQ,
                         Low : 'X',
                     },
                 ],
             },
         ],
     },
     SelectionVariant#open  : {
         $Type : 'UI.SelectionVariantType',
         ID : 'open',
         Text : 'open',
         Parameters : [
             
         ],             
         FilterExpression : '',
         SelectOptions : [
             {
                 $Type : 'UI.SelectOptionType',
                 PropertyName : TravelStatus_code,
                 Ranges : [
                     {
                         $Type : 'UI.SelectionRangeType',
                         Sign : #I,
                         Option : #EQ,
                         Low : 'O',
                     },
                 ],
             },
         ],
     },
      SelectionVariant#accepted  : {
         $Type : 'UI.SelectionVariantType',
         ID : 'accepted',
         Text : 'accepted',
         Parameters : [
             
         ],             
         FilterExpression : '',
         SelectOptions : [
             {
                 $Type : 'UI.SelectOptionType',
                 PropertyName : TravelStatus_code,
                 Ranges : [
                     {
                         $Type : 'UI.SelectionRangeType',
                         Sign : #I,
                         Option : #EQ,
                         Low : 'A',
                     },
                 ],
             },
         ],
     }
 };
annotate TravelService.Travel with @(
    UI.DataPoint #TravelStatus_code : {
        $Type : 'UI.DataPointType',
        Value : TravelStatus_code,
        Title : '{i18n>TravelStatus}',
        Criticality : TravelStatus.criticality,
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TravelStatus_code',
            Target : '@UI.DataPoint#TravelStatus_code',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TotalPrice',
            Target : '@UI.DataPoint#TotalPrice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Progress',
            Target : '@UI.DataPoint#progress1',
        },
    ]
);
annotate TravelService.Travel with @(
    UI.DataPoint #TotalPrice : {
        $Type : 'UI.DataPointType',
        Value : TotalPrice,
        Title : '{i18n>TotalPrice}',
    }
);
annotate TravelService.Travel with @(
    UI.DataPoint #progress : {
        $Type : 'UI.DataPointType',
        Value : Progress,
        Title : 'Progress',
        TargetValue : 100,
        Visualization : #Progress,
    }
);
annotate TravelService.Travel with @(
    UI.DataPoint #progress1 : {
        $Type : 'UI.DataPointType',
        Value : Progress,
        Title : '{i18n>ProgressOfTravel}',
        TargetValue : 100,
        Visualization : #Progress,
    }
);
annotate TravelService.Booking with @(
    UI.DataPoint #TotalSupplPrice1 : {
        Value : TotalSupplPrice,
        MinimumValue : 0,
        MaximumValue : 120,
        TargetValue            : 100,
        Visualization          : #BulletChart,
        //  Criticality : TotalSupplPrice, // it has precedence over criticalityCalculation => in order to have the criticality color do not use it
        CriticalityCalculation : {
            $Type                  : 'UI.CriticalityCalculationType',
            ImprovementDirection   : #Maximize,
            DeviationRangeLowValue : 20,
            ToleranceRangeLowValue : 75
        }
    },
    UI.Chart #TotalSupplPrice1 : {
        ChartType : #Bullet,
        Title : '{i18n>TotalSupplements}',
        Measures : [
            TotalSupplPrice,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#TotalSupplPrice1',
                Role : #Axis1,
                Measure : TotalSupplPrice,
            },
        ],
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TotalSupplPrice',
            Target : '@UI.Chart#TotalSupplPrice1',
        },
    ]
);
annotate TravelService.Travel with {
    Description @UI.MultiLineText : true
    @UI.Placeholder : '{i18n>DescrPlcehlder}'
};

annotate TravelService.Travel @(
    Common.SideEffects#ReactonItemCreationOrDeletion : {
        SourceEntities : [
            to_Booking
        ],
       TargetProperties : [
           'TotalPrice'
       ]
    }
);
