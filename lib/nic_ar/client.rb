module NicAr

  # Simple HTTP client for accessing the public {nic!alert API}[http://api.nicalert.com.ar].
  #
  # Full API spec. available at {api.nicalert.com.ar}[http://api.nicalert.com.ar]
  #
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
        #424: Failed Dependency
        when 424
          raise CaptchaError, message
        #406: Not Acceptable
        when 406  
          raise RequestError, message
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
