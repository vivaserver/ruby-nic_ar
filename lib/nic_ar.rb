require 'cgi'
require 'json'
require 'rubygems'
require 'bundler/setup'
require 'rest_client'

# NicAr is the _official_ Ruby gem for accessing the {nic!alert API}[http://api.nicalert.me]. See the README.rdoc

module NicAr
  # The base URI for the nic!alert API
  API_URI = 'http://api.nicalert.me/v1'

  # status HTTP 204: No Content
  class NoContent < StandardError; end  

  # status HTTP 400: Bad Request
  class RequestError < StandardError; end  

  # status HTTP 404: Not Found
  class NotFound < StandardError; end  

  # status HTTP 408: Request Timeout
  class TimeoutError < StandardError; end  

  # status HTTP 412: Precondition Failed
  class PreconditionError < StandardError; end  

  # status HTTP 417: Expectation Failed (available?, pending?)
  class ExpectationError < StandardError; end  

  # status HTTP 424: Failed Dependency
  class CaptchaError < StandardError; end  

  # status HTTP 500: System Error
  class ServiceError < StandardError; end  

  # status HTTP 503: Service Unavailable
  class UnavailableError < StandardError; end  
end

require "nic_ar/client"
require "nic_ar/version"
