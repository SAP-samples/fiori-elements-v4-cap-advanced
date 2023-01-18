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
    TravelID: String @readonly @Common.Text: Description
  } actions {
    action createTravelByTemplate() returns Travel;
    action rejectTravel();
    action acceptTravel();
  };

  // Passenger: Add joined property 'FullName' and composition 'to_Booking'
  entity Passenger as projection on my.Passenger {
    *,
    FirstName || ' ' || LastName as FullName: String,
    to_Booking: Composition of many my.Booking on to_Booking.to_Customer = $self
  }

  // Booking, Travel, Passenger: Use "FullName" as text annotation of CustomerID
  entity Booking as projection on my.Booking
  annotate Booking {
    to_Customer @Common.Text: to_Customer.FullName
  }  
  annotate Travel {
    to_Customer @Common.Text: to_Customer.FullName
  }
  annotate Passenger {
    CustomerID @Common.Text: FullName;
  }

  // Ensure all masterdata entities are available to clients
  annotate my.MasterData with @cds.autoexpose @readonly;
}

type Percentage : Integer @assert.range: [1,100];
