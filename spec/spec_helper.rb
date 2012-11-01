require_relative '../lib/nic_ar'
require 'minitest/autorun'
require 'webmock/minitest'

def stub_for(request)
  File.read(File.join(File.dirname(__FILE__),'stubs',"#{request}.json"))
end
