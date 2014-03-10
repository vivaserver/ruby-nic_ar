module NicAr
  # NicAr::Client
  # Simple HTTP client for accessing the {public nic!alert API}[http://api.nicalert.me].
  # Full API spec. available at {api.nicalert.com.ar/docs}[http://api.nicalert.me/docs]
  #
  # (c)2014 Cristian R. Arroyo <cristian.arroyo@vivaserver.com>

  class Client
    attr_reader :token

    def initialize(token=nil)
      @token = token
    end

    def whois(name=nil)  #:nodoc:
      if name
        request "whois/#{name}" + (@token.nil? || @token.empty?? '' : "?token=#{@token}")
      else
        request "whois"
      end
    end

    private

    def request(path)  #:nodoc:
      response = RestClient.get("#{api_host}/#{path}")
      JSON.parse(response)
    rescue RestClient::Exception => e
      message = message_from(e.http_body)
      case e.http_code
      when 400  # Bad Request
        fail RequestError, message
      when 404  # Not Found
        fail NotFound
      when 408  # Request Timeout
        fail TimeoutError, message
      when 412  # Precondition Failed
        fail PreconditionError, message  # PageError
      when 424  # Failed Dependency
        fail CaptchaError, message       # CaptchaError
      when 500  # System Error
        fail ServiceError, message
      when 503  # Service Unavailable
        fail UnavailableError, message
      else
        raise e
      end
    end

    def message_from(response)  #:nodoc:
      result = JSON.parse(response)
      result['error']['message'] if result.has_key? 'error'
    rescue
      nil
    end

    # override to support multiple API hosts
    def api_host  #:nodoc:
      API_URI
    end
  end
end
