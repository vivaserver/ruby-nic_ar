require_relative 'spec_helper'

describe 'nic!alert API client' do
  it 'raises ArgumentError if no parameter to resource given' do
    proc { NicAr::Client.people }.must_raise ArgumentError
  end

  describe 'using stubbed API responses' do
    it 'has flexible support for multiple arguments' do
      RestClient.stub :get, response('transactions/macusadas.com.ar.REN') do
        result = NicAr::Client.domains 'macusadas.com.ar', 'transactions'
        result.must_be_instance_of Array
        transaction = result.first
        transaction.must_be_instance_of Hash
        transaction['id'].must_equal 'REN17330833'
        transaction['status'].must_equal 'FINALIZADO'
        transaction['description'].must_equal 'Renovacion de Nombre'
      end
    end

    describe 'DNS lookups' do
      it 'returns a hash for primary DNS lookups' do
        RestClient.stub :get, response('dns_servers/ns1.sedoparking.com') do
          result = NicAr::Client.dns_servers 'ns1.sedoparking.com'
          result.must_be_instance_of Hash
          result['host'].must_equal   'ns1.sedoparking.com'
          result['handle'].must_equal 'NICAR-H24966'
        end
      end

      it 'returns a hash for secondary DNS lookups' do
        RestClient.stub :get, response('dns_servers/ns2.sedoparking.com') do
          result = NicAr::Client.dns_servers 'ns2.sedoparking.com'
          result.must_be_instance_of Hash
          result['host'].must_equal 'ns2.sedoparking.com'
          result['handle'].must_equal 'NICAR-H24965'
        end
      end
    end

    describe 'Domains lookups' do
      it 'returns Nil for Domain 404s' do
        skip
        RestClient.stub :get, proc { raise RestClient::ResourceNotFound } do
          proc { NicAr::Client.domains 'hispafuentes.com.ar' }.must_raise NicAr::NotFound
        end
      end

      it 'returns a Hash for Domain lookups' do
        RestClient.stub :get, response('domains/dww.com.ar') do
          result = NicAr::Client.domains 'dww.com.ar'
          result.must_be_instance_of Hash
          result['name'].must_equal   'dww'
          result['domain'].must_equal '.com.ar'
        end
      end
    end

    describe 'Entities lookups' do
      it 'returns an Entity hash for lookups' do
        RestClient.stub :get, response('entities/Sedo.com LLC') do
          result = NicAr::Client.entities 'Sedo.com LLC'
          result.must_be_instance_of Hash
          result['name'].must_equal   'Sedo.com LLC'
          result['handle'].must_equal 'NICAR-E779784'
        end
      end
    end

    describe 'Persons lookups' do
      it 'returns a Person hash for lookups' do
        RestClient.stub :get, response('persons/Sedo.com LLC - Technical Contact') do
          result = NicAr::Client.persons 'Sedo.com LLC - Technical Contact'
          result.must_be_instance_of Hash
          result['name'].must_equal   'Sedo.com LLC - Technical Contact'
          result['handle'].must_equal 'NICAR-P1280916'
        end
      end
    end

    describe 'Transactions lookups' do
      it 'returns a Transactions array for domains lookups' do
        RestClient.stub :get, response('transactions/macusadas.com.ar.REN') do
          result = NicAr::Client.transactions 'macusadas.com.ar'
          result.must_be_instance_of Array
          result.count.must_equal 1
          transaction = result.first
          transaction.must_be_instance_of Hash
          transaction['id'].must_equal 'REN17330833'
          transaction['status'].must_equal 'FINALIZADO'
          transaction['description'].must_equal 'Renovacion de Nombre'
        end
      end

      it 'returns a Transaction hash for single transaction lookups' do
        RestClient.stub :get, response('transactions/REN17330833') do
          result = NicAr::Client.transactions 'REN17330833'
          result['domain'].must_equal 'macusadas.com.ar'
          result['status'].must_equal 'FINALIZADO'
          result['description'].must_equal 'Renovacion de Nombre'
        end
      end
    end
  end
end
