require_relative '../lib/nic_ar'
require 'minitest/autorun'

def response(request)
  JSON.parse(File.read(File.join(File.dirname(__FILE__),'stubs',"#{request}.json")))
end
