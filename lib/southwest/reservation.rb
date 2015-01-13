require_relative './request'

module Southwest
  class Reservation < Request
    def self.retrieve_reservation(last_name:, first_name:, record_locator:)
      new(last_name: last_name,
          first_name: first_name,
          record_locator: record_locator).retrieve_reservation
    end

    def retrieve_reservation
      response = {}
      response[:raw] = make_request(base_params.merge({
        serviceID: 'viewAirReservation',
        searchType:  'ConfirmationNumber',
        submitButton: 'Continue',
        creditCardLastName: '',
        creditCardFirstName: '',
        confirmationNumber:  record_locator,
        confirmationNumberFirstName: first_name,
        confirmationNumberLastName:  last_name,
        creditCardDepartureDate: todays_date_formatted
      }))
      response[:reservation] = JSON.parse(response[:raw].body)
      response
    end

    private

    def make_request(params)
      response = Typhoeus::Request.post(base_uri, body: params, headers: headers)
      store_cookies(response)
      response
    end

    # Example: '01/10/2015'
    def todays_date_formatted
      Time.now.strftime('%m/%d/%Y')
    end
  end
end
