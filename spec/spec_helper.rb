require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/nic_ar'

def stub_for(request)
  File.read(File.join(File.dirname(__FILE__),'stubs',"#{request}.json"))
end
