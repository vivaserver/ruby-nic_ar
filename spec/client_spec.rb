require_relative 'spec_helper'

describe 'NicAr::Client' do
  subject do
    NicAr::Client.new
  end

  it 'deprecates some old methods' do
    assert subject.respond_to? :whois
    refute subject.respond_to? :domains
    refute subject.respond_to? :entities
    refute subject.respond_to? :people
    refute subject.respond_to? :transactions
  end

  describe 'Domains lookups' do
    it 'knows what kind of domains to lookup' do
      stub_request(:get,/whois$/).to_return(:body => '[".com.ar", ".gob.ar", ".int.ar", ".mil.ar", ".net.ar", ".org.ar", ".tur.ar"]')
      result = subject.whois
      result.must_be_instance_of Array
      result.wont_be_empty
    end

    it 'raises on unexisting domains' do
      stub_request(:get,/whois\/hispafuentes\.com\.ar$/).to_return(:status => 404)
      proc { subject.whois 'hispafuentes.com.ar' }.must_raise NicAr::NotFound
    end

    it 'returns a Hash for Domain lookups' do
      stub_request(:get,/whois\/dww\.com\.ar$/).to_return(:body => stub_for('domains/dww.com.ar'))
      result = subject.whois 'dww.com.ar'
      result.must_be_instance_of Hash
      result['name'].must_equal 'dww.com.ar'
    end
  end
end
