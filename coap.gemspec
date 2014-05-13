# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coap/version'

Gem::Specification.new do |spec|
  spec.name          = "coap"
  spec.version       = Coap::VERSION
  spec.authors       = ["Carsten Bormann","Simon Frerichs"]
  spec.email         = ["morpheus@morphhome.net"]
  spec.summary       = %q{Ruby Gem for RFC 7252 - Constrained Application Protocol (CoAP)}
  spec.description   = %q{Ruby Gem for RFC 7252 - Constrained Application Protocol (CoAP)
The Constrained Application Protocol (CoAP) is a specialized web
transfer protocol for use with constrained nodes and constrained
(e.g., low-power, lossy) networks.  The nodes often have 8-bit
microcontrollers with small amounts of ROM and RAM, while constrained
networks such as 6LoWPAN often have high packet error rates and a
typical throughput of 10s of kbit/s.  The protocol is designed for
machine-to-machine (M2M) applications such as smart energy and
building automation}
  spec.homepage      = "https://github.com/SmallLars/coap"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.0'

  spec.add_dependency "resolv-ipv6favor"
#  spec.add_dependency "codtls"
end
