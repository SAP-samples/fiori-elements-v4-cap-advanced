const cds = require ('@sap/cds'); require('./workarounds')

class TravelService extends cds.ApplicationService {
init() {

  /**
   * Reflect definitions from the service's CDS model
   */
  const { Travel, Booking, BookingSupplement } = this.entities


  /**
   * Function import handler: getBookingDataOfPassenger
   * @param CustomerID
   * @returns BookingData
   */
  this.on('getBookingDataOfPassenger', async (req) => {
    const { CustomerID } = req.data
    const allCustomerBookings = await SELECT `BookingStatus_code as status`.from (Booking) .where `to_Customer_CustomerID = ${CustomerID}`
    const bookingData = {
      TotalBookingsCount: 0,
      NewBookingsCount: 0,
      AcceptedBookingsCount: 0,
      CancelledBookingsCount: 0
    }
    allCustomerBookings.forEach((booking) => {
      bookingData.TotalBookingsCount++
      switch (booking.status) {
        case 'N':
          bookingData.NewBookingsCount++
          break
        case 'B':
          bookingData.AcceptedBookingsCount++
          break          
        case 'X':
          bookingData.CancelledBookingsCount++
          break
        default:
          break
      }
    })
    return bookingData;
  });
  
  /**
   * Fill in primary keys for new Travels.
   * Note: In contrast to Bookings and BookingSupplements that has to happen
   * upon SAVE, as multiple users could create new Travels concurrently.
   */
  this.before ('CREATE', 'Travel', async req => {
    const { maxID } = await SELECT.one `max(TravelID) as maxID` .from (Travel)
    req.data.TravelID = maxID + 1
  })


  /**
   * Fill in defaults for new Bookings when editing Travels.
   */
  this.before ('NEW', 'Booking', async (req) => {
    const { to_Travel_TravelUUID } = req.data
    const { status } = await SELECT `TravelStatus_code as status` .from (Travel.drafts, to_Travel_TravelUUID)
    if (status === 'X') throw req.reject (400, 'Cannot add new bookings to rejected travels.')
    const { maxID } = await SELECT.one `max(BookingID) as maxID` .from (Booking.drafts) .where ({to_Travel_TravelUUID})
    req.data.BookingID = maxID + 1
    req.data.BookingStatus_code = 'N'
    req.data.BookingDate = (new Date).toISOString().slice(0,10) // today
  })


  /**
   * Fill in defaults for new BookingSupplements when editing Travels.
   */
  this.before ('NEW', 'BookingSupplement', async (req) => {
    const { to_Booking_BookingUUID } = req.data
    const { maxID } = await SELECT.one `max(BookingSupplementID) as maxID` .from (BookingSupplement.drafts) .where ({to_Booking_BookingUUID})
    req.data.BookingSupplementID = maxID + 1
  })


  /**
   * Changing Booking Fees is only allowed for not yet accapted Travels.
   */
  this.before ('PATCH', 'Travel', async (req) => { if ('BookingFee' in req.data) {
    const { status } = await SELECT `TravelStatus_code as status` .from (req._target)
    if (status === 'A') req.reject(400, 'Booking fee can not be updated for accepted travels.', 'BookingFee')
  }})


  /**
   * Update the Travel's TotalPrice when its BookingFee is modified.
   */
  this.after ('PATCH', 'Travel', (_,req) => { if ('BookingFee' in req.data) {
    return this._update_totals4 (req.data.TravelUUID)
  }})


  /**
   * Update the Travel's TotalPrice when a Booking's FlightPrice is modified.
   */
  this.after ('PATCH', 'Booking', async (_,req) => { if ('FlightPrice' in req.data) {
    // We need to fetch the Travel's UUID for the given Booking target
    const { travel } = await SELECT.one `to_Travel_TravelUUID as travel` .from (req._target)
    return this._update_totals4 (travel)
  }})


  /**
   * Update the Travel's TotalPrice when a Supplement's Price is modified.
   */
  this.after ('PATCH', 'BookingSupplement', async (_,req) => { if ('Price' in req.data) {
    // We need to fetch the Travel's UUID for the given Supplement target
    const { booking } = await SELECT.one `to_Booking_BookingUUID as booking` 
.from (BookingSupplement.drafts).where({BookSupplUUID:req.data.BookSupplUUID})
    const { travel } = await SELECT.one `to_Travel_TravelUUID as travel` .from (Booking.drafts)
      .where `BookingUUID = ${booking} `
      // .where `BookingUUID = ${ SELECT.one `to_Booking_BookingUUID` .from (req._target) }`
      //> REVISIT: req._target not supported for subselects -> see tests
      await this._update_totals_supplement (booking)
    return this._update_totals4 (travel)
  }})

  /**
   * Update the Booking's TotalSupplPrice
   */
this._update_totals_supplement = async function (booking) {
    const { totals } = await SELECT.one `coalesce (sum (Price),0) as totals` .from (BookingSupplement.drafts) .where
     `to_Booking_BookingUUID = ${booking}`
    return  UPDATE (Booking.drafts, booking) .with({TotalSupplPrice: totals})
}

  /**
   * Update the Travel's TotalPrice when a Booking Supplement is deleted.
   */
  this.on('CANCEL', BookingSupplement, async (req, next) => {
    // Find out which travel is affected before the delete
    const { DraftAdministrativeData_DraftUUID, BookSupplUUID } = req.data
    const { to_Travel_TravelUUID } = await SELECT.one
      .from(BookingSupplement.drafts, ['to_Travel_TravelUUID'])
      .where({ DraftAdministrativeData_DraftUUID, BookSupplUUID })
    // Delete handled by generic handlers
    const res = await next()
    // After the delete, update the totals
    await this._update_totals4(to_Travel_TravelUUID)
    return res
  })
  
  /**
   * Update the Travel's TotalPrice when a Booking is deleted.
   */
  this.on('CANCEL', Booking, async (req, next) => {
    // Find out which travel is affected before the delete
    const { DraftAdministrativeData_DraftUUID, BookingUUID } = req.data
    const { to_Travel_TravelUUID } = await SELECT.one
      .from(Booking.drafts, ['to_Travel_TravelUUID'])
      .where({ DraftAdministrativeData_DraftUUID, BookingUUID })
    // Delete handled by generic handlers
    const res = await next()
    // After the delete, update the totals
    await this._update_totals4(to_Travel_TravelUUID)
    return res
  })


  /**
   * Helper to re-calculate a Travel's TotalPrice from BookingFees, FlightPrices and Supplement Prices.
   */
  this._update_totals4 = function (travel) {
    return UPDATE (Travel.drafts, travel) .with ({ TotalPrice: CXL `coalesce (BookingFee, 0) + ${
      SELECT `coalesce (sum (FlightPrice + ${
        SELECT `coalesce (sum (Price),0)` .from (BookingSupplement.drafts) .where `to_Booking_BookingUUID = BookingUUID`
      }),0)` .from (Booking.drafts) .where `to_Travel_TravelUUID = TravelUUID`
    }` })
  }


  /**
   * Validate a Travel's edited data before save.
   */
  this.before ('SAVE', 'Travel', req => {
    const { BeginDate, EndDate } = req.data, today = (new Date).toISOString().slice(0,10)
    if (BeginDate < today) req.error (400, `Begin Date ${BeginDate} must not be before today ${today}.`, 'in/BeginDate')
    if (BeginDate > EndDate) req.error (400, `Begin Date ${BeginDate} must be before End Date ${EndDate}.`, 'in/BeginDate')
  })

/**
   * Calculate the progress of the travel booking.
   */

  // Travel is new (0 bookings) = 10%
  // Travel contains at least one booking = 50%
  // Travel contains at least two bookings = 65%
  // Supplement target reached + 5 % per booking, max 90%
  // Travel is accepted = 100% -> see acceptTravel
  // Travel is rejected = 0% -> see rejectTravel
  this.before ('SAVE', 'Travel', async req => {
    if (!req.event === 'CREATE' && !req.event === 'UPDATE') return //only calculate if create or update
    let score = 10
    const { TravelUUID } = req.data
    const res = await SELECT .from(Booking.drafts) .where `to_Travel_TravelUUID = ${TravelUUID}`
    if (res.length >= 1) score += 40
    if (res.length >= 2) score += 15
    res.forEach(element => {
      if (element.TotalSupplPrice > 70) score += 5
    });
    if (score > 90) score = 90;
    req.data.Progress = score
  })

  //
  // Action Implementations...
  //

  this.on ('acceptTravel', async req => {
    await UPDATE (req._target) .with ({TravelStatus_code:'A'})
    return this._update_progress(req._target, 100)
  })
  this.on ('rejectTravel', async req => {
    await UPDATE (req._target) .with ({TravelStatus_code:'X'})
    return this._update_progress(req._target, 0)
  })

  this._update_progress = async function (travel, progress){
    return await UPDATE (travel) . with({Progress : progress})
  }
  
  this.on ('deductDiscount', async req => {
    let discount = req.data.percent / 100
    let succeeded = await UPDATE (req._target)
      .where `TravelStatus_code != 'A'`
      .and `BookingFee is not null`
      .with (`
        TotalPrice = round (TotalPrice - BookingFee * ${discount}, 3),
        BookingFee = round (BookingFee - BookingFee * ${discount}, 3)
      `)
    if (!succeeded) { //> let's find out why...
      let travel = await SELECT.one `TravelID as ID, TravelStatus_code as status, BookingFee` .from (req._target)
      if (!travel) throw req.reject (404, `Travel "${travel.ID}" does not exist; may have been deleted meanwhile.`)
      if (travel.status === 'A') req.reject (400, `Travel "${travel.ID}" has been approved already.`)
      if (travel.BookingFee == null) throw req.reject (404, `No discount possible, as travel "${travel.ID}" does not yet have a booking fee added.`)
    } else {
      // Note: it is important to read from this, not db to include draft handling
      // REVISIT: through req._target workaround, IsActiveEntity is non-enumerable, which breaks this.read(Travel, req.params[0])
      const [{ TravelUUID, IsActiveEntity }] = req.params
      return this.read(Travel, { TravelUUID, IsActiveEntity })
    }
  })

  // Add base class's handlers. Handlers registered above go first.
  return super.init()

}}
module.exports = {TravelService}
