require_relative 'spec_helper'

describe 'NicAr::Client' do
  it 'fixes respond_to?' do
    assert NicAr::Client.respond_to? :dns_servers
    assert NicAr::Client.respond_to? :domains
    assert NicAr::Client.respond_to? :entities
    assert NicAr::Client.respond_to? :people
    assert NicAr::Client.respond_to? :transactions
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

  describe 'DNS lookups' do
    it 'returns a hash for primary DNS lookups' do
      stub_request(:get,/dns_servers\/ns1\.sedoparking\.com$/).to_return(:body => stub_for('dns_servers/ns1.sedoparking.com'))
      result = NicAr::Client.dns_servers 'ns1.sedoparking.com'
      result.must_be_instance_of Hash
      result['host'].must_equal   'ns1.sedoparking.com'
      result['handle'].must_equal 'NICAR-H24966'
    end

    it 'returns a hash for secondary DNS lookups' do
      stub_request(:get,/dns_servers\/ns2\.sedoparking\.com$/).to_return(:body => stub_for('dns_servers/ns2.sedoparking.com'))
      result = NicAr::Client.dns_servers 'ns2.sedoparking.com'
      result.must_be_instance_of Hash
      result['host'].must_equal 'ns2.sedoparking.com'
      result['handle'].must_equal 'NICAR-H24965'
    end
  end

  describe 'Domains lookups' do
    it 'knows what kind of domains to lookup' do
      stub_request(:get,/domains$/).to_return(:body => '[".com.ar", ".gov.ar", ".int.ar", ".mil.ar", ".net.ar", ".org.ar", ".tur.ar"]')
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
      result['name'].must_equal   'dww'
      result['domain'].must_equal '.com.ar'
    end
  end

  describe 'Entities lookups' do
    it 'returns an Entity hash for lookups' do
      stub_request(:get,/entities\/Sedo\.com.LLC$/).to_return(:body => stub_for('entities/Sedo.com LLC'))
      result = NicAr::Client.entities 'Sedo.com LLC'
      result.must_be_instance_of Hash
      result['name'].must_equal   'Sedo.com LLC'
      result['handle'].must_equal 'NICAR-E779784'
    end
  end

  describe 'People lookups' do
    it 'returns a Person hash for lookups' do
      stub_request(:get,/people\/Sedo\.com.LLC.-.Technical.Contact$/).to_return(:body => stub_for('people/Sedo.com LLC - Technical Contact'))
      result = NicAr::Client.people 'Sedo.com LLC - Technical Contact'
      result.must_be_instance_of Hash
      result['name'].must_equal   'Sedo.com LLC - Technical Contact'
      result['handle'].must_equal 'NICAR-P1280916'
    end
  end

  describe 'Transactions lookups' do
    it 'returns a Transactions array for domains lookups' do
      stub_request(:get,/transactions\/macusadas\.com\.ar$/).to_return(:body => stub_for('transactions/macusadas.com.ar.REN'))
      result = NicAr::Client.transactions 'macusadas.com.ar'
      result.must_be_instance_of Array
      result.count.must_equal 1
      transaction = result.first
      transaction.must_be_instance_of Hash
      transaction['id'].must_equal 'REN17330833'
      transaction['status'].must_equal 'FINALIZADO'
      transaction['description'].must_equal 'Renovacion de Nombre'
    end

    it 'returns a Transaction hash for single transaction lookups' do
      stub_request(:get,/transactions\/REN17330833$/).to_return(:body => stub_for('transactions/REN17330833'))
      result = NicAr::Client.transactions 'REN17330833'
      result['domain'].must_equal 'macusadas.com.ar'
      result['status'].must_equal 'FINALIZADO'
      result['description'].must_equal 'Renovacion de Nombre'
    end

    it 'has flexible support for multiple arguments' do
      stub_request(:get,/domains\/macusadas\.com\.ar\/transactions$/).to_return(:body => stub_for('transactions/macusadas.com.ar.REN'))
      result = NicAr::Client.domains 'macusadas.com.ar', 'transactions'
      result.must_be_instance_of Array
      transaction = result.first
      transaction.must_be_instance_of Hash
      transaction['id'].must_equal 'REN17330833'
      transaction['status'].must_equal 'FINALIZADO'
      transaction['description'].must_equal 'Renovacion de Nombre'
    end

    it 'might return no transactions at all' do
      stub_request(:get,/transactions\/hispafuentes\.com\.ar$/).to_return(:status => 204)
      proc { NicAr::Client.transactions 'hispafuentes.com.ar' }.must_raise NicAr::NoContent
    end
  end
end
