module CoAP
  # CoAP client library
  class Block
     def self.initialize(num, more, szx)
       @logger = CoAP.logger

       { more: more, szx: szx, num: num }
     end

     def self.encode(num, more, szx)
       block = szx | more << 3 | num << 4

       @logger.debug '### CoAP Block encode ###'
       @logger.debug block
       @logger.debug '### CoAP Block encode ###'

       block
     end

     def self.encode_hash(blockHash)
       blockHash[:more] ? more = 1 : more = 0
       block = blockHash[:szx] | more << 3 | blockHash[:num] << 4

       @logger.debug '### CoAP Block encode ###'
       @logger.debug block
       @logger.debug '### CoAP Block encode ###'

       block
     end

     def self.decode(blockOption)
       more = blockOption != nil && (blockOption & 8) === 8
       szx = blockOption != nil ? blockOption & 7 : 0
       num = blockOption != nil ? blockOption >> 4 : 0

       @logger.debug '### CoAP Block decode ###'
       @logger.debug 'm: ' + more.to_s
       @logger.debug 'szx: ' + szx.to_s
       @logger.debug 'num: ' + num.to_s
       @logger.debug '### CoAP Block decode ###'

       { more: more, szx: szx, num: num }
     end
  end
end
