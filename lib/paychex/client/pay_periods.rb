module Paychex
  class Client
    module PayPeriods
      # Get a list of all the company pay periods
      def pay_periods(company_id, options={})
        status = ['RELEASED']
        begin
          response = get("companies/#{company_id}/payperiods", options)
          response.body.fetch('content').to_a
        rescue => e
          Rails.logger.error e.errors.inspect
          []
        end
      end
    end
  end
end
