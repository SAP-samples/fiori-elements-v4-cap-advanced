using TravelService as service from '../../srv/travel-service';

annotate service.Passenger with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : FullName,
        },{
            $Type : 'UI.DataField',
            Value : CountryCode.code,
        },{
            $Type : 'UI.DataField',
            Value : CountryCode.descr,
        },{
            $Type : 'UI.DataField',
            Value : PostalCode,
        },{
            $Type : 'UI.DataField',
            Value : Street,
        },{
            $Type : 'UI.DataField',
            Value : City,
        },]
);
annotate service.Passenger with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : CountryCode_code,
            },
            {
                $Type : 'UI.DataField',
                Value : PostalCode,
            },
            {
                $Type : 'UI.DataField',
                Value : City,
            },
            {
                $Type : 'UI.DataField',
                Value : Street,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
    ]
);
annotate service.Passenger with @(
    UI.SelectionFields : [
        CountryCode_code,
        City,
        PostalCode,
    ]
);
annotate service.Passenger with @(
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Contact Details',
            ID : 'ContactDetails',
            Target : '@UI.FieldGroup#ContactDetails1',
        },],
    UI.FieldGroup #ContactDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    }
);
annotate service.Passenger with @(
    UI.FieldGroup #ContactDetails1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : to_Booking.to_Customer.FullName,
                Label : 'FullName',
            },{
                $Type : 'UI.DataField',
                Value : to_Booking.to_Customer.PhoneNumber,
            },{
                $Type : 'UI.DataField',
                Value : to_Booking.to_Customer.EMailAddress,
            },],
    }
);
annotate service.Passenger with @(
    UI.HeaderInfo : {
        TypeName : '{i18n>CustomerID}',
        TypeNamePlural : '{i18n>Customers}',
        Title : {
            $Type : 'UI.DataField',
            Value : FullName,
        },
    }
);
