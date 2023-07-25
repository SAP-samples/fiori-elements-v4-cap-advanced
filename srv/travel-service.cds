using { sap.fe.cap.travel as my } from '../db/schema';

service TravelService @(path:'/processor') {

  @(restrict: [
    { grant: 'READ', to: 'authenticated-user'},
    { grant: ['rejectTravel','acceptTravel','deductDiscount'], to: 'reviewer'},
    { grant: ['*'], to: 'processor'},
    { grant: ['*'], to: 'admin'}
  ])

  // Travel: To avoid number formatting of the travel ID, make it a String
  entity Travel as projection on my.Travel {
    *,
    TravelID: String @readonly @Common.Text: Description,

    // ***CustomerID***
    to_Customer.FirstName || ' ' || to_Customer.LastName as CustomerFullName : String,
    @Common.Text: CustomerFullName
    to_Customer,

    // ***AgencyID***
    to_Agency.Name                                       as AgencyName,
    @Common.Text: AgencyName
    to_Agency,

    // ***Passenger Country***
    to_Customer.CountryCode.name as PassengerCountryName,
    @Common.Text: PassengerCountryName
    to_Customer.CountryCode.code                         as PassengerCountry,

    // **TravelStatus**
    TravelStatus.name as TravelStatusName,
    @Common.Text: TravelStatusName
    TravelStatus
  } actions {
    action createTravelByTemplate() returns Travel;
    action rejectTravel();
    action acceptTravel();
  };

  // Passenger: Add joined property 'FullName' and association 'to_Booking'
  entity Passenger as projection on my.Passenger {
    *,
    FirstName || ' ' || LastName as FullName: String @title : '{i18n>fullName}',
    to_Booking: Association to many my.Booking on to_Booking.to_Customer = $self
  }

  // Booking, Travel, Passenger: Use "FullName" as text annotation of CustomerID
  annotate Booking {
    to_Customer @Common.Text: to_Customer.FullName
  }  
  annotate Passenger {
    CustomerID @Common.Text: FullName;
  }

  // Ensure all masterdata entities are available to clients
  annotate my.MasterData with @cds.autoexpose @readonly;
}

type Percentage : Integer @assert.range: [1,100];
