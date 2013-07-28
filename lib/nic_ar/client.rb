module NicAr

  # NicAr::Client
  # Simple HTTP client for accessing the {public nic!alert API}[http://api.nicalert.com.ar].
  # Full API spec. available at {api.nicalert.com.ar/docs}[http://api.nicalert.com.ar/docs]
  #
  # (c)2013 Cristian R. Arroyo <cristian.arroyo@vivaserver.com>

  class Client
    class << self
      # Maps class methods to API calls
      def method_missing(name, *args)
        params = '/' + args.map { |p| CGI.escape(p) }.join('/') unless args.empty?
        resource = name.to_s
        # send the bang! trailing the request (upcoming API feat.)
        if unbanged = resource[/(\w+)!$/,1]
          resource = unbanged
          params = "#{params}!"
        end
        get "/#{resource}#{params}"
      end

      # Acknowledge supported methods/API calls
      def respond_to?(resource)
        return true if %w[dns_servers domains entities people transactions].include? resource.to_s
        super
      end

      private

      def get(path)  #:nodoc:
        response = RestClient.get("#{api_host}/#{path}")
        raise NoContent if response.code == 204
        JSON.parse(response)
      rescue RestClient::Exception => e
        message = message_from(e.http_body)

        case e.http_code
        when 400  # Bad Request
          raise ParameterError, message
        when 404  # Not Found
          raise NotFound
        when 406  # Not Acceptable
          raise RequestError, message
        when 408  # Request Timeout
          raise TimeoutError, message
        when 412  # Precondition Failed
          raise PreconditionError, message
        when 417  # Expectation Failed
          raise ExpectationError, message
        when 424  # Failed Dependency
          raise CaptchaError, message
        when 500  # System Error
          raise ServiceError, message
        when 503  # Service Unavailable
          raise UnavailableError, message
        else
          raise e
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
