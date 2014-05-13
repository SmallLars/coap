[![Gem Version](https://badge.fury.io/rb/coap.png)](http://badge.fury.io/rb/coap)
[![Dependency Status](https://gemnasium.com/SmallLars/coap.png)](https://gemnasium.com/SmallLars/coap)
[![Build Status](https://travis-ci.org/SmallLars/coap.png?branch=master)](https://travis-ci.org/SmallLars/coap)
[![Coverage Status](https://coveralls.io/repos/SmallLars/coap/badge.png?branch=master)](https://coveralls.io/r/SmallLars/coap)
[![Code Climate](https://codeclimate.com/github/SmallLars/coap.png)](https://codeclimate.com/github/SmallLars/coap)

# Gem CoAP

Ruby Gem for RFC 7252 - Constrained Application Protocol (CoAP)<br>
Based on code by Carsten Bormann<br>

The Constrained Application Protocol (CoAP) is a specialized web
transfer protocol for use with constrained nodes and constrained
(e.g., low-power, lossy) networks.  The nodes often have 8-bit
microcontrollers with small amounts of ROM and RAM, while constrained
networks such as 6LoWPAN often have high packet error rates and a
typical throughput of 10s of kbit/s.  The protocol is designed for
machine-to-machine (M2M) applications such as smart energy and
building automation.<br>


Implemented Version: RFC (http://tools.ietf.org/html/rfc7252)<br>

Additionally implemented:

 - Blockwise Transfer http://tools.ietf.org/html/draft-ietf-core-block-14
 - Observe http://tools.ietf.org/html/draft-ietf-core-observe-13

## Install
Add this line to your application's Gemfile:

    gem 'coap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coap

## Usage

### In your ruby/rails application


    client = CoAP::Client.new
    answer = client.get('coap.me', 5683, '/hello')
    p answer.payload

Lot's of examples are stored in test/test_client.rb<br>
Code is commented in rdoc format

### Command Line Client (very limited)

    ./client get coap://coap.me:5683/.well-known/core

## Testing

    rake test

## Copyright
Copyright (C) 2014 Simon Frerichs. See LICENSE.txt for further details.<br>
Based on code by Carsten Bormann
