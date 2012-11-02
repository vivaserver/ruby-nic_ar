require 'cgi'
require 'json'
require 'rubygems'
require 'bundler/setup'
require 'rest_client'

module NicAr
  API_URI = 'http://api.nicalert.com.ar'

  # exceptions match API's error codes

  class CaptchaError      < StandardError; end  #424: Failed Dependency
  class RequestError      < StandardError; end  #406: Not Acceptable
  class ExpectationError  < StandardError; end  #417: Expectation Failed (available?, pending?)
  class NoContent         < StandardError; end  #204: No Content
  class NotFound          < StandardError; end  #404: Not Found
  class ParameterError    < StandardError; end  #400: Bad Request
  class PreconditionError < StandardError; end  #412: Precondition Failed
  class ServiceError      < StandardError; end  #500: System Error
  class TimeoutError      < StandardError; end  #408: Request Timeout
end

require "nic_ar/client"
require "nic_ar/version"
