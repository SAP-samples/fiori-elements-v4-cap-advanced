using { Currency, custom.managed, sap.common.CodeList } from './common';
using {
  sap.fe.cap.travel.Airline,
  sap.fe.cap.travel.Passenger,
  sap.fe.cap.travel.TravelAgency,
  sap.fe.cap.travel.Supplement,
  sap.fe.cap.travel.Flight
 } from './master-data';

namespace sap.fe.cap.travel;

type BookingData: {
  TotalBookingsCount: Integer;
  NewBookingsCount: Integer;
  AcceptedBookingsCount: Integer;
  CancelledBookingsCount: Integer;
}

entity Travel : managed {
  key TravelUUID : UUID;
  TravelID       : Integer @readonly default 0;
  BeginDate      : Date;
  EndDate        : Date;
  BookingFee     : Decimal(16, 3);
  TotalPrice     : Decimal(16, 3) @readonly;
  CurrencyCode   : Currency;
  Progress       : Integer @readonly;
  Description    : String(1024);
  TravelStatus   : Association to TravelStatus @readonly;
  to_Agency      : Association to TravelAgency @assert.target;
  to_Customer    : Association to Passenger;
  to_Booking     : Composition of many Booking on to_Booking.to_Travel = $self;
};

entity Booking : managed {
  key BookingUUID   : UUID;
  BookingID         : Integer @Core.Computed;
  BookingDate       : Date;
  ConnectionID      : String(4);
  FlightDate        : Date;
  FlightPrice       : Decimal(16, 3);
  CurrencyCode      : Currency;
  BookingStatus     : Association to BookingStatus;
  TotalSupplPrice   : Decimal(16, 3);
  to_BookSupplement : Composition of many BookingSupplement on to_BookSupplement.to_Booking = $self;
  to_Carrier        : Association to Airline;
  to_Customer       : Association to Passenger;
  to_Travel         : Association to Travel;
  to_Flight         : Association to Flight on  to_Flight.AirlineID = to_Carrier.AirlineID
                                            and to_Flight.FlightDate = FlightDate
                                            and to_Flight.ConnectionID = ConnectionID;
};

entity BookingSupplement : managed {
  key BookSupplUUID   : UUID;
  BookingSupplementID : Integer @Core.Computed;
  Price               : Decimal(16, 3);
  DeliveryPreference  : Association to  MealOptionDeliveryPreference;
  CurrencyCode        : Currency;
  to_Booking          : Association to Booking;
  to_Travel           : Association to Travel;
  to_Supplement       : Association to Supplement;
};


//
//  Code Lists
//

entity BookingStatus : CodeList {
  key code : String enum {
    New      = 'N';
    Booked   = 'B';
    Canceled = 'X';
  };
};

entity TravelStatus : CodeList {
  key code : String enum {
    Open     = 'O';
    Accepted = 'A';
    Canceled = 'X';
  } default 'O'; //> will be used for foreign keys as well
  criticality : Integer; //  2: yellow colour,  3: green colour, 0: unknown
  fieldControl: Integer @odata.Type:'Edm.Byte'; // 1: #ReadOnly, 7: #Mandatory
  createDeleteHidden: Boolean;
  insertDeleteRestriction: Boolean; // = NOT createDeleteHidden
  cancelRestrictions: Boolean; // is true for cancelled travels
}

annotate Travel with @(
Capabilities: {
	FilterRestrictions : {FilterExpressionRestrictions : [{
		Property	: 'BeginDate',
		AllowedExpressions: 'SingleRange'
	},
	{
		Property	: 'EndDate',
		AllowedExpressions: 'SingleRange'
	}]}
});

//for dynamic Delete action
annotate TravelService.Travel with @(
 Capabilities.DeleteRestrictions : {
     $Type : 'Capabilities.DeleteRestrictionsType',
    Deletable: TravelStatus.insertDeleteRestriction
 }   
);

@odata.singleton
entity SupplementScope {
  MinimumValue           : Integer @Common.Label: 'Minimum Value';
  MaximumValue           : Integer @Common.Label: 'Maximum Value';
  TargetValue            : Integer @Common.Label: 'Target Value';
  DeviationRangeLowValue : Integer @Common.Label: 'Deviation Range Threshold';
  ToleranceRangeLowValue : Integer @Common.Label: 'Tolerance Range Threshold';  
};

entity MealOptionDeliveryPreference: CodeList {
  key code : String enum {
    SoonAfterTakeoff = 'S';
    Midflight = 'M';
    Late = 'L';
  } default 'M'
};
