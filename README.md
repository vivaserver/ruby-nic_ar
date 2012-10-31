# NicAr::Client

The NicAr::Client gem allows to programatically extract information about any ".ar" (Argentina) domain name. 

It uses the public information as is made available at the [Dirección Nacional del Registro de Dominios de Internet](http://www.nic.ar) via the third-party [nic!alert API](http://api.nicalert.com.ar) webservice.

## Installation

Add this line to your application's Gemfile:

    gem 'nic_ar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nic_ar

## Usage

The NicAr::Client class supports lookups for domain names, domain transactions, entities, people, DNS servers.

All the following lookups will raise a NicAr::NotFound exception if the requested resource could not be found.

    NicAr::Client.domains("vivaserver.com.ar")
    => {
         "available"=>false,
         "delegated"=>true,
         "expiring"=>false,
         "pending"=>false,
         "registered"=>true,
         "name"=>"vivaserver",
         "domain"=>".com.ar",
         "created_on"=>"2004-11-18",
         "expires_on"=>"2012-11-18",
         "contacts"=> {
           "registrant"=>{
             "name"=>"Cristian Renato Arroyo",
             "occupation"=>"Diseno de Paginas Web",
             "address"=>"Pje. Vucetich 676. Ciudad De Nieva",
             "city"=>"S. S. de Jujuy",
             "province"=>"Jujuy",
             "zip_code"=>"4600",
             "country"=>"Argentina",
             "phone"=>"(0388)155827713",
             "fax"=>"(0388)155827713"},
           "responsible"=>{
             "name"=>"Cristian Renato Arroyo",
             "address"=>"Pje. Vucetich 676. Ciudad De Nieva.",
             "city"=>"S. S. de jujuy",
             "province"=>"Jujuy",
             "zip_code"=>"4600",
             "country"=>"Argentina",
             "phone"=>"(0388)155827713",
             "fax"=>"(0388)155827713",
             "work_hours"=>"8am-1pm"},
           "administrative"=>{
             "name"=>"Dynamic DNS Network Services",
             "address"=>"210 Park Ave. #267",
             "city"=>"Worcester",
             "province"=>"",
             "zip_code"=>"MA 01609",
             "country"=>"USA",
             "phone"=>"1-508-798-2145",
             "fax"=>"1-508-798-5748",
             "activity"=>"Network Services"},
           "technical"=>{
             "name"=>"Andre Dure",
             "address"=>"Humahuaca 1303",
             "city"=>"Capital Federal",
             "province"=>"Ciudad de Buenos Aires",
             "zip_code"=>"C1405BIA",
             "country"=>"Argentina",
             "phone"=>"49588864",
             "fax"=>"43335885",
             "work_hours"=>"10 a 22"}
           },
         "dns_servers"=>{
           "primary"=>{"host"=>"ns1.mydyndns.org", "ip"=>nil},
           "secondary"=>{"host"=>"ns2.mydyndns.org", "ip"=>nil},
           "alternate1"=>{"host"=>"ns3.mydyndns.org", "ip"=>nil},
           "alternate2"=>{"host"=>"ns4.mydyndns.org", "ip"=>nil},
           "alternate3"=>{"host"=>"ns5.mydyndns.org", "ip"=>nil}
         }
       }

All registered domains have a related entities (registrant/administrative contacts) and persons (responsible/technical contacts).

    NicAr::Client.entities("Dynamic DNS Network Services")
    => {
         "name"=>"Dynamic DNS Network Services",
         "type"=>"ADMINISTRADORA",
         "address"=>"210 Park Ave. #267",
         "city"=>"Worcester",
         "province"=>nil,
         "country"=>"USA",
         "activity"=>"Network Services",
         "handle"=>"NICAR-E607791"
       }

    NicAr::Client.people("Andre Dure")
    => {"name"=>"Andre Dure", "handle"=>"NICAR-P425476"}

DNS Servers can also be queried by hostname or IP.

    NicAr::Client.dns_servers("ns1.mydyndns.org")
    => {
         "host"=>"ns1.mydyndns.org",
         "ip"=>nil,
         "owner"=>"Andre Dure",
         "operator"=>"Andre Dure",
         "handle"=>"NICAR-H12587"
       }

If a domain name has no recent transactions, a NicAr::NoContent exception will be raised. Otherwise an array of recent transactions will be returned.

    NicAr::Client.transactions("nazarenorock.com.ar")
    => [{
          "id"=>"REG18127727",
          "created_at"=>"2012-10-03T15:11:01-03:00",
          "description"=>"Registro de Nombre",
          "status"=>"PENDIENTE",
          "notes"=>"Se envio acuse de recibo al solicitante"
        }]

Transactions can also be queried by it's unique identifier:

    NicAr::Client.transactions("REG18127727")
    => {
         "domain"=>"nazarenorock.com.ar",
         "created_at"=>"2012-10-03T15:11:01-03:00",
         "description"=>"Registro de Nombre",
         "status"=>"PENDIENTE",
         "notes"=>"Se envio acuse de recibo al solicitante"
       }

The full documentation of the nic!alert API is available at [api.nicalert.com.ar](http://api.nicalert.com.ar) if you want to write your own client, use any other language, or just use CURL in a RESTful way.

## Live sample

A live test application is set up at the [nic!alert](http://www.nicalert.com.ar) website that allows for the automatic renewal of ".ar" domain names within their 30-day expiring period. The application also has the added feature of resolving the CAPTCHA challenge for the submission of the renewal request.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c)2012 [Cristian R. Arroyo](mailto:cristian.arroyo@vivasserver.com). MIT Licensed.
