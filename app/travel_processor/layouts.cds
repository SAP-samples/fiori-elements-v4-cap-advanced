using TravelService from '../../srv/travel-service';
using from '@sap/cds/common';
using from '../../db/schema';

//
// annotatios that control the fiori layout
//

annotate TravelService.Travel with @UI : {

  Identification : [
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.acceptTravel',   Label  : '{i18n>AcceptTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.rejectTravel',   Label  : '{i18n>RejectTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.deductDiscount', Label  : '{i18n>DeductDiscount}' }
  ],
  HeaderInfo : {
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
  PresentationVariant : {
    Text           : 'Default',
    Visualizations : ['@UI.LineItem'],
    SortOrder      : [{
      $Type      : 'Common.SortOrderType',
      Property   : TravelID,
      Descending : true
    }]
  },
  SelectionFields : [
    to_Agency_AgencyID,
    to_Customer_CustomerID,
    TravelStatus_code
  ],
  LineItem : [
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.acceptTravel',   Label  : '{i18n>AcceptTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.rejectTravel',   Label  : '{i18n>RejectTravel}'   },
    { $Type  : 'UI.DataFieldForAction', Action : 'TravelService.deductDiscount', Label  : '{i18n>DeductDiscount}' },
    {
      Value : TravelID,
      ![@UI.Importance] : #High
    },
    { Value : to_Agency_AgencyID     },
    {
      Value : to_Customer_CustomerID,
      ![@UI.Importance] : #High
    },
    { Value : BeginDate              },
    { Value : EndDate                },
    { Value : BookingFee             },
    { Value : TotalPrice             },
    {
      $Type : 'UI.DataField',
      Value : TravelStatus_code,
      Criticality : TravelStatus.criticality,
      ![@UI.Importance] : #High
    },
    {
        $Type : 'UI.DataFieldForAnnotation',
        Target : '@UI.DataPoint#progress',
        Label: 'progress of travel'
    },
      {
          $Type : 'UI.DataFieldForAnnotation',
          Target : 'CurrencyCode/@UI.DataPoint#exponent',
          Label : 'exponent',
      },
      {
          $Type : 'UI.DataFieldForAnnotation',
          Target : 'TravelStatus/@UI.DataPoint#criticality',
          Label : 'criticality',
      }
  ],
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>GeneralInformation}',
    ID     : 'Travel',
    Facets : [
      {  // travel details
        $Type  : 'UI.ReferenceFacet',
        ID     : 'TravelData',
        Target : '@UI.FieldGroup#TravelData',
        Label  : '{i18n>GeneralInformation}'
      },
      {  // price information
        $Type  : 'UI.ReferenceFacet',
        ID     : 'PriceData',
        Target : '@UI.FieldGroup#PriceData',
        Label  : '{i18n>Prices}'
      }/* , // Tanya : remove this block for the exercise/demo Add date, multi line text
      {  // date information
        $Type  : 'UI.ReferenceFacet',
        ID     : 'DateData',
        Target : '@UI.FieldGroup#DateData',
        Label  : '{i18n>Dates}'
      } */
      ]
  }, {  // booking list
    $Type  : 'UI.ReferenceFacet',
    Target : 'to_Booking/@UI.PresentationVariant',
    Label  : '{i18n>Bookings}'
  }],
  FieldGroup#TravelData : { Data : [
    { Value : TravelID               },
    { Value : to_Agency_AgencyID     },
    { Value : to_Customer_CustomerID },
    { Value : Description            },
    {
      $Type       : 'UI.DataField',
      Value       : TravelStatus_code,
      Criticality : TravelStatus.criticality,
      Label : '{i18n>Status}' // label only necessary if differs from title of element
    }
  ]},
  FieldGroup #DateData : {Data : [
    { $Type : 'UI.DataField', Value : BeginDate },
    { $Type : 'UI.DataField', Value : EndDate }
  ]},
  FieldGroup #PriceData : {Data : [
    { $Type : 'UI.DataField', Value : BookingFee },
    { $Type : 'UI.DataField', Value : TotalPrice }
  ]}
};

annotate TravelService.Booking with @UI : {
  Identification : [
    { Value : BookingID },
  ],
  HeaderInfo : {
    TypeName       : '{i18n>Bookings}',
    TypeNamePlural : '{i18n>Bookings}',
    Title          : { Value : to_Customer.LastName },
    Description    : { Value : BookingID }
  },
  PresentationVariant : {
    Visualizations : ['@UI.LineItem'],
    SortOrder      : [{
      $Type      : 'Common.SortOrderType',
      Property   : BookingID,
      Descending : false
    }]
  },
  SelectionFields : [],
  LineItem : [
    { Value : to_Carrier.AirlinePicURL,  Label : '  '},
    { Value : BookingID              },
    { Value : BookingDate            },
    { Value : to_Customer_CustomerID },
    { Value : to_Carrier_AirlineID   },
    { Value : ConnectionID,          Label : '{i18n>FlightNumber}' },
    { Value : FlightDate             },
    { Value : FlightPrice            },
    { Value : BookingStatus_code     },
    { Value : TotalSupplPrice,       Label : 'TotalSupplPrice'       },    // Tanya temporary added
    {
        $Type : 'UI.DataFieldForAnnotation', // Tanya added for bullet micro chart
        Target : '@UI.Chart#SupplPrice',
        Label : 'Supplements'
    }
  ],
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : '{i18n>GeneralInformation}',
    ID     : 'Booking',
    Facets : [{  // booking details
      $Type  : 'UI.ReferenceFacet',
      ID     : 'BookingData',
      Target : '@UI.FieldGroup#GeneralInformation',
      Label  : '{i18n>Booking}'
    }, {  // flight details
      $Type  : 'UI.ReferenceFacet',
      ID     : 'FlightData',
      Target : '@UI.FieldGroup#Flight',
      Label  : '{i18n>Flight}'
    }]
  }, {  // supplements list
    $Type  : 'UI.ReferenceFacet',
    Target : 'to_BookSupplement/@UI.PresentationVariant',
    Label  : '{i18n>BookingSupplements}'
  }],
  FieldGroup #GeneralInformation : { Data : [
    { Value : BookingID              },
    { Value : BookingDate,           },
    { Value : to_Customer_CustomerID },
    { Value : BookingDate,           },
    { Value : BookingStatus_code     }
  ]},
  FieldGroup #Flight : { Data : [
    { Value : to_Carrier_AirlineID   },
    { Value : ConnectionID           },
    { Value : FlightDate             },
    { Value : FlightPrice            }
  ]},
};

annotate TravelService.BookingSupplement with @UI : {
  Identification : [
    { Value : BookingSupplementID }
  ],
  HeaderInfo : {
    TypeName       : '{i18n>BookingSupplement}',
    TypeNamePlural : '{i18n>BookingSupplements}',
    Title          : { Value : BookingSupplementID },
    Description    : { Value : BookingSupplementID }
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
  LineItem : [
    { Value : BookingSupplementID                                       },
    { Value : to_Supplement_SupplementID, Label : '{i18n>ProductID}'    },
    { Value : Price,                      Label : '{i18n>ProductPrice}' }
  ],
};

annotate TravelService.Flight with @UI : {
  PresentationVariant#SortOrderPV : {    // used in the value help for ConnectionId in Bookings
    SortOrder      : [{
      Property   : FlightDate,
      Descending : true
    }]
  }
};

/* annotate TravelService.Travel with @UI : {
    SelectionPresentationVariant#canceled  : {
        $Type : 'UI.SelectionPresentationVariantType',
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
                {
                    $Type : 'UI.SelectOptionType',
                    PropertyName : TravelStatus_code,
                    Ranges : [
                        {
                            $Type : 'UI.SelectionRangeType',
                            Sign : #E,
                            Option : #EQ,
                            Low : 'A',
                            High : 'O'
                        },
                    ],
                },
            ],
            
        },
        Text : 'Canceled',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            ID : 'canceled',
            Text : 'canceled travels',
           
            Visualizations : [
                '@UI.LineItem#canceled',
            ]
        },
    },
    LineItem #canceled                     : [
        {
            Value             : TravelID,
            ![@UI.Importance] : #High
        },
        {Value : to_Agency_AgencyID},
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
        }
    ],
    SelectionPresentationVariant#open  : {
        $Type : 'UI.SelectionPresentationVariantType',
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
                {
                    $Type : 'UI.SelectOptionType',
                    PropertyName : TravelStatus_code,
                    Ranges : [
                        {
                            $Type : 'UI.SelectionRangeType',
                            Option : #EQ,
                            Low : 'O'
                        },
                    ],
                },
            ],
            
        },
        Text : 'Open',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            ID : '',
            Text : '',
           
            Visualizations : [
                '@UI.LineItem',
            ]
        },
    }
} ;
 */

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

annotate TravelService.Booking @(
    UI.Chart #SupplPrice  : {
    $Type : 'UI.ChartDefinitionType',
    ChartType : #Bullet,
    Title : 'total supplements',
    Description : 'bullet',
    AxisScaling : {
        $Type : 'UI.ChartAxisScalingType',
        
    },
    Measures : [TotalSupplPrice  
    ],
    MeasureAttributes : [
        {
            $Type : 'UI.ChartMeasureAttributeType',
            Measure : TotalSupplPrice,
            Role : #Axis1,
            DataPoint : '@UI.DataPoint#SupplPrice'
        }
    ]
},
UI.DataPoint #SupplPrice : {
    $Type : 'UI.DataPointType',
    Value : TotalSupplPrice,
    Title : 'data point title',
    Description : 'description of data point',
    LongDescription : 'long description of data point',
    TargetValue : 70,
    MinimumValue : 0,
    MaximumValue : 100,
    Visualization : #BulletChart,
  //  Criticality : TotalSupplPrice, // it has precedence over criticalityCalculation => in order to have the criticality color do not use it
    CriticalityCalculation : {
        $Type : 'UI.CriticalityCalculationType',
        ImprovementDirection : #Maximize,
        DeviationRangeLowValue : 20,
        ToleranceRangeLowValue : 50
    }
}
 );

annotate TravelService.Travel @(
    UI.DataPoint #progress: {
        $Type : 'UI.DataPointType',
        Value : Progress,
        TargetValue : 100,
        Visualization : #Progress
    }
);

// to add the Bullet Micro Chart to the OP Header Facet
annotate TravelService.Booking @(
    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.Chart#SupplPrice'
        }
    ]
);

// to add the progress indicator to the OP Header facet
annotate TravelService.Travel @(
    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.DataPoint#progress'
        }
    ]
 );

// TravelService.Travel.Description with @UI.MultiLineText; das ist falsch!

annotate TravelService.Travel with {Description @UI.MultiLineText};

annotate TravelService.Travel with {Description @UI.Placeholder : '{i18n>DescrPlcehlder}'};



annotate TravelService.Currencies with @(
    UI.DataPoint #exponent : {
        Value : exponent,
        Visualization : #Progress,
        TargetValue : 100,
    }
);
annotate TravelService.TravelStatus with @(
    UI.DataPoint #criticality : {
        Value : criticality,
        Visualization : #Progress,
        TargetValue : 100,
    }
);
