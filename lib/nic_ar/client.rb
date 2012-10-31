module NicAr
  class Client
    class << self
      def method_missing(name, *args)
        unless args.empty?
          params = args.map { |p| CGI.escape(p) }.join '/'
          resource = name.to_s
          # send the bang! trailing the request (upcoming API feat.)
          if unbanged = resource[/(\w+)!$/,1]
            resource = unbanged
            params += '!'
          end
          get "/#{resource}/#{params}"
        else
          raise ArgumentError
        end
      end

      private

      def get(path)  #:nodoc:
        RestClient.get("#{api_host}/#{path}") do |response, request, result, &block|
          message = message_from(response)

          case response.code
          #200: Success
          when 200
            JSON.parse(response)

          #204: No Content
          when 204
            raise NoContent

          #424: Failed Dependency
          when 424
            raise CaptchaError, message

          #406: Not Acceptable
          when 406  
            raise DomainError, message

          #417: Expectation Failed
          when 417  
            raise ExpectationError, message

          #404: Not Found
          when 404
            raise NotFound

          #400: Bad Request
          when 400
            raise ParameterError, message

          #412: Precondition Failed
          when 412
            raise PreconditionError, message

          #408: Request Timeout
          #503: Service Unavailable
          when 408, 503
            raise TimeoutError, message

          #500: System Error
          when 500
            raise ServiceError, message

          else
            response.return!(request, response, &block)
          end
        end
      end

      def message_from(response)  #:nodoc:
        JSON.parse(response)['message']
      rescue
        nil
      end

      # override to support multiple API hosts

      def api_host  #:nodoc:
        API_URI
      end
    end
  end
end
