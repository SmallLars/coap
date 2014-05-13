# encoding: utf-8
module CoAP
  module_function

  def logger
    if @logger.nil?
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
    end

    @logger
  end
  def logger= logger
    @logger.close unless @logger.nil?
    
    @logger = logger
  end
end

require 'logger'
require 'socket'
require 'resolv-ipv6favor'
require 'ipaddr'
require 'timeout'
#require 'CoDTLS'

require 'coap/coap.rb'
require 'coap/message.rb'
require 'coap/block.rb'
require 'coap/mysocket.rb'
require 'coap/observer.rb'
require 'coap/client.rb'

require 'misc/hexdump.rb'