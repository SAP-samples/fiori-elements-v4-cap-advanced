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
                Value : createdAt,
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy,
            },
            {
                $Type : 'UI.DataField',
                Value : LastChangedAt,
            },
            {
                $Type : 'UI.DataField',
                Value : LastChangedBy,
            },
            {
                $Type : 'UI.DataField',
                Value : CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : FirstName,
            },
            {
                $Type : 'UI.DataField',
                Value : LastName,
            },
            {
                $Type : 'UI.DataField',
                Value : Title,
            },
            {
                $Type : 'UI.DataField',
                Value : Street,
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
                Value : CountryCode_code,
            },
            {
                $Type : 'UI.DataField',
                Value : PhoneNumber,
            },
            {
                $Type : 'UI.DataField',
                Value : EMailAddress,
            },
            {
                $Type : 'UI.DataField',
                Label : 'FullName',
                Value : FullName,
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
