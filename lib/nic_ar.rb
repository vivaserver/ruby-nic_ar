require 'cgi'
require 'json'
require 'rubygems'
require 'bundler/setup'
require 'rest_client'

# NicAr is the _official_ Ruby gem for accessing the {nic!alert API}[http://api.nicalert.com.ar]. See the README.rdoc

module NicAr
  # The base URI for the nic!alert API.
  API_URI = 'http://api.nicalert.com.ar'

  # Exception for status HTTP 424: Failed Dependency
  class CaptchaError < StandardError; end  

  # Exception for status HTTP 406: Not Acceptable
  class RequestError < StandardError; end  

  # Exception for status HTTP 417: Expectation Failed (available?, pending?)
  class ExpectationError < StandardError; end  

  # Exception for status HTTP 204: No Content
  class NoContent < StandardError; end  

  # Exception for status HTTP 404: Not Found
  class NotFound < StandardError; end  

  # Exception for status HTTP 400: Bad Request
  class ParameterError < StandardError; end  

  # Exception for status HTTP 412: Precondition Failed
  class PreconditionError < StandardError; end  

  # Exception for status HTTP 500: System Error
  class ServiceError < StandardError; end  

  # Exception for status HTTP 503: Service Unavailable
  class UnavailableError < StandardError; end  

  # Exception for status HTTP 408: Request Timeout, 503: Service Unavailable
  class TimeoutError < StandardError; end  
end

require "nic_ar/client"
require "nic_ar/version"
