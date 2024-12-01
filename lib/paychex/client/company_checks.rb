module Paychex
  class Client
    module CompanyChecks
      # Get a list of all the company checks
      def company_checks(company_id, options)
        begin
          response = get("companies/#{company_id}/checks", options)
          response.body.fetch('content').to_a
        rescue => e
          Rails.logger.error e.errors.inspect
          []
        end
      end
    end
  end
end
