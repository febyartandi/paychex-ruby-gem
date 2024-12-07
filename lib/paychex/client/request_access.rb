module Paychex
  class Client
    module RequestAccess
      def request_access(company_id)
        begin
          response = post("management/requestclientaccess", { 'displayId' => company_id })
          response.body.dig('approvalLink')
        rescue => e
          Rails.logger.error e.errors.inspect
          ''
        end
      end
    end
  end
end
