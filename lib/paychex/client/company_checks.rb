module Paychex
  class Client
    module CompanyChecks
      REQUEST_FORMAT = 'application/vnd.paychex.payroll.processedchecks.v1+json'.freeze
      # Get a list of all the company checks
      def company_checks(company_id, options)
        begin
          response = get_request("companies/#{company_id}/checks", options)
          response.body.fetch('content').to_a
        rescue => e
          Rails.logger.error e.errors.inspect
          []
        end
      end

      def get_request(path, params)
        encoded_path = Addressable::URI.escape(path)

        faraday_connection.get do |request|
          request.url(encoded_path, params)
        end
      end

      def faraday_connection
        options = {
          headers: {
            'Accept' => REQUEST_FORMAT,
            'Content-Type' => REQUEST_FORMAT,
            'User-Agent' => user_agent
          },
          url: endpoint,
        }
        Faraday::Connection.new(options) do |conn|
          conn.authorization :Bearer, access_token unless access_token.nil?
          conn.options[:timeout] = timeout
          conn.options[:open_timeout] = open_timeout
          conn.request :json
          conn.request :instrumentation, name: 'request.paychex'

          conn.use ::PaychexFaradayMiddleWare::RaisePaychexHttpException
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
