require_relative 'spec_helper'

describe 'NicAr::Client' do
  it 'fixes respond_to?' do
    refute NicAr::Client.respond_to? :dns_servers  # old resources deprecated by new Nic.ar website
    assert NicAr::Client.respond_to? :domains
    refute NicAr::Client.respond_to? :entities
    refute NicAr::Client.respond_to? :people
    refute NicAr::Client.respond_to? :transactions
  end

  describe 'when receiving invalid requests' do
    it 'rejects single invalid requests' do
      stub_request(:get,/invalid_request$/).to_return(:status => 406)
      proc { NicAr::Client.invalid_request }.must_raise NicAr::RequestError
    end

    it 'also rejects invalid requests with parameters' do
      stub_request(:get,/invalid_request\/with\/parameters$/).to_return(:status => 406)
      proc { NicAr::Client.invalid_request 'with', 'parameters' }.must_raise NicAr::RequestError
    end
  end

  describe 'Domains lookups' do
    it 'knows what kind of domains to lookup' do
      stub_request(:get,/domains$/).to_return(:body => '[".com.ar", ".gob.ar", ".int.ar", ".mil.ar", ".net.ar", ".org.ar", ".tur.ar"]')
      result = NicAr::Client.domains
      result.must_be_instance_of Array
      result.wont_be_empty
    end

    it 'raises on unexisting domains' do
      stub_request(:get,/domains\/hispafuentes\.com\.ar$/).to_return(:status => 404)
      proc { NicAr::Client.domains 'hispafuentes.com.ar' }.must_raise NicAr::NotFound
    end

    it 'returns a Hash for Domain lookups' do
      stub_request(:get,/domains\/dww\.com\.ar$/).to_return(:body => stub_for('domains/dww.com.ar'))
      result = NicAr::Client.domains 'dww.com.ar'
      result.must_be_instance_of Hash
      result['name'].must_equal 'dww.com.ar'
    end
  end
end
