module CoAP

  # CoAP client library
  class Client

    # attr_writer
    #
    # @param max_payload optional payload size, default 256
    # @param max_retransmit optional retransmit count, default 4
    # @param ack_timeout optional ack_timeout, default 2
    # @param hostname dest optional hostname
    # @param port dest optional port
    attr_writer :max_payload, :max_retransmit, :ack_timeout, :hostname, :port

    # new arguments
    #
    # @param max_payload optional payload size, default 256
    # @param max_retransmit optional retransmit count, default 4
    # @param ack_timeout optional ack_timeout, default 2
    # @param hostname dest optional hostname
    # @param port dest optional port
    def initialize(max_payload = 256, max_retransmit = 4, ack_timeout = 2, hostname = nil, port = nil)
      @max_payload = max_payload
      @max_retransmit = max_retransmit
      @ack_timeout = ack_timeout

      @hostname = hostname
      @port = port

      # dont change the following stuff
      @retry_count = 0

      @MySocket = MySocket.new
      @MySocket.socket_type = UDPSocket
      @MySocket.ack_timeout = @ack_timeout

      @logger = CoAP.logger
    end

    # Enable DTLS Socket
    # Needs CoDTLS Gem
    def use_dtls
      @MySocket = MySocket.new
      @MySocket.socket_type = CoDTLS::SecureSocket
      @MySocket.ack_timeout = @ack_timeout

      self
    end

    def chunk(string, size)
      chunks = []
      string.bytes.each_slice(size) { |i| chunks << i.pack('C*') }
      chunks
      # string.scan(/.{1,#{size}}/)
    end

    def decode_url(url)
      url_decoded = CoAP.scheme_and_authority_decode(url)

      @logger.debug 'url decoded: ' + url_decoded.inspect
      fail ArgumentError, 'Invalid URL' if url_decoded.nil?

      url_decoded
    end

    # simple coap get
    #
    # @param url coap scheme + authority url eg coap://coap.me:5683/time
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def get_by_url(url, options = {})
      url_decoded = CoAP.scheme_and_authority_decode(url)

      @logger.debug 'url decoded: ' + url_decoded.inspect
      fail ArgumentError, 'Invalid URL' if url_decoded.nil?

      get(url_decoded[0], url_decoded[1], url_decoded[2], options)
    end

    # simple coap get
    #
    # @param hostname hostname or ip address
    # @param port port to connect to
    # @param uri eg /.well-known/core
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def get(hostname, port, uri, options = {})
      @retry_count = 0
      client(hostname, port, uri, :get, nil, options)
    end

    # coap post
    #
    # @param url coap scheme + authority url eg coap://coap.me:5683/time
    # @param payload payload which should be send
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def post_by_url(url, payload, options = {})
      url_decoded = CoAP.scheme_and_authority_decode(url)

      @logger.debug 'url decoded: ' + url_decoded.inspect
      fail ArgumentError, 'Invalid URL' if url_decoded.nil?

      post(url_decoded[0], url_decoded[1], url_decoded[2], payload, options)
    end

    # coap post
    #
    # @param hostname hostname or ip address
    # @param port port to connect to
    # @param uri eg /.well-known/core
    # @param payload payload which should be send
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def post(hostname, port, uri, payload, options = {})
      @retry_count = 0
      client(hostname, port, uri, :post, payload, options)
    end

    # coap put
    #
    # @param url coap scheme + authority url eg coap://coap.me:5683/time
    # @param payload payload which should be send
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def put_by_url(url, payload, options = {})
      url_decoded = CoAP.scheme_and_authority_decode(url)

      @logger.debug 'url decoded: ' + url_decoded.inspect
      fail ArgumentError, 'Invalid URL' if url_decoded.nil?

      put(url_decoded[0], url_decoded[1], url_decoded[2], payload, options)
    end

    # coap put
    #
    # @param hostname hostname or ip address
    # @param port port to connect to
    # @param uri eg /.well-known/core
    # @param payload payload which should be send
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def put(hostname, port, uri, payload, options = {})
      @retry_count = 0
      client(hostname, port, uri, :put, payload, options)
    end

    # coap delete
    #
    # @param url coap scheme + authority url eg coap://coap.me:5683/time
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def delete_by_url(hostname, port, uri, options = {})
      url_decoded = CoAP.scheme_and_authority_decode(url)

      @logger.debug 'url decoded: ' + url_decoded.inspect
      fail ArgumentError, 'Invalid URL' if url_decoded.nil?

      delete(url_decoded[0], url_decoded[1], url_decoded[2], options)
    end

    # coap delete
    #
    # @param hostname hostname or ip address
    # @param port port to connect to
    # @param uri eg /.well-known/core
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def delete(hostname, port, uri, options = {})
      @retry_count = 0
      client(hostname, port, uri, :delete, nil, options)
    end

    # coap observe
    #
    # @param url coap scheme + authority url eg coap://coap.me:5683/time
    # @param options coap options
    # @param callback method to call with the observe data eg. observe_callback(payload, socket)
    #
    def observe_by_url(hostname, port, uri, callback, options = {})
      url_decoded = CoAP.scheme_and_authority_decode(url)

      @logger.debug 'url decoded: ' + url_decoded.inspect
      fail ArgumentError, 'Invalid URL' if url_decoded.nil?

      observe(url_decoded[0], url_decoded[1], url_decoded[2], callback, options)
    end

    # coap observe
    #
    # @param hostname hostname or ip address
    # @param port port to connect to
    # @param uri eg /.well-known/core
    # @param options coap options
    # @param callback method to call with the observe data eg. observe_callback(payload, socket)
    #
    def observe(hostname, port, uri, callback, options = {})
      options[:observe] = 0
      client(hostname, port, uri, :get, nil, options, callback)
    end

    # custom client for special use
    #
    # @param url coap scheme + authority url eg coap://coap.me:5683/time
    # @param method string get post put delete etc
    # @param payload message payload
    # @param options coap options
    #
    # @return CoAP::Message #<struct CoAP::Message ver=1, tt=:ack, mcode=[2, 5], mid=866, options={:max_age=>60, :token=>150, :etag=>[16135160785136240028], :content_format=>40, :block2=>226}, payload=\"\\\";ct=50,</5>;rt=\\\"5\\\";ct=50\">"
    def custom(url, method, payload = nil, options = {})

      url_decoded = decode_url url
      client(url_decoded[0], url_decoded[1], url_decoded[2], method.to_sym, payload, options)

    end

    private

    def client(hostname, port, uri, method, payload, options, observe_callback = nil)

      # set hostname + port only one time on multiple requests
      hostname.nil? ? (hostname = @hostname unless @hostname.nil?) : @hostname = hostname
      port.nil? ? (port = @port unless @port.nil?) : @port = port

      # Error handling for paramaters
      fail ArgumentError, 'hostname missing' if hostname.nil? || hostname.empty?
      fail ArgumentError, 'port missing' if port.nil?
      fail ArgumentError, 'port must ba an integer' unless port.is_a? Integer
      fail ArgumentError, 'uri missing' if uri.nil? || uri.empty?
      fail ArgumentError, 'payload must be a string' unless payload.is_a? String unless payload.nil?
      fail ArgumentError, 'payload shouldnt be empty ' if payload.empty? unless payload.nil?

      # generate random message id
      mid = Random.rand(999)
      token = Random.rand(256)
      szx = Math.log2(@max_payload).floor - 4

      # initialize block 2 with payload size
      block2 = Block.initialize(0, false, szx) 

      # initialize block1 if set
      block1 = options[:block1].nil? ? Block.initialize(0, false, szx) : Block.decode(options[:block1])

      # initialize chunks if payload size > max_payload
      chunks = chunk(payload, 2**((Math.log2(@max_payload).floor - 4) + 4)) unless payload.nil?

      # create coap message struct
      message = Message.new(:con, method, mid, nil, {})
      # , block2: Block.encode_hash(block2)
      message.options = { uri_path: CoAP.path_decode(uri), token: token }
      message.options[:block2] = Block.encode_hash(block2) if @max_payload != 256 # temp fix to disable early negotation
      message.payload = payload unless payload.nil?

      ### initialize stuff end

      # if chunks.size 1 > we need to use block1
      if !payload.nil? and chunks.size > 1
        # increase block number
        block1[:num] += 1 unless options[:block1].nil?
        # more ?
        block1[:more] = chunks.size > block1[:num] + 1
        chunks.size > block1[:num] + 1 ? message.options.delete(:block2) : block1[:more] = false
        # set final payload
        message.payload = chunks[block1[:num]]
        # set message option
        message.options[:block1] = Block.encode_hash(block1)
      end

      # preserve user options
      message.options[:block2] = options[:block2] unless options[:block2] == nil
      message.options[:observe] = options[:observe] unless options[:observe] == nil
      message.options.merge(options)

      # debug functions
      @logger.debug '### CoAP Send Data ###'
      #@logger.debug message.to_s.hexdump
      @logger.debug message.inspect
      @logger.debug '### CoAP Send Data ###'

      # connect via udp/dtls
      @MySocket.connect hostname, port
      @MySocket.send message.to_wire, 0

      # send message + retry
      begin
        recv_data = @MySocket.receive
      rescue Timeout::Error
        @retry_count += 1
        raise 'Retry Timeout ' + @retry_count.to_s if @retry_count > @max_retransmit
        return client(hostname, port, uri, method, payload, options, observe_callback)
      end

      # parse recv data
      recv_parsed = CoAP.parse(recv_data[0].force_encoding('BINARY'))

      # debug functions
      @logger.debug '### CoAP Received Data ###'
      #@logger.debug recv_parsed.to_s.hexdump
      @logger.debug recv_parsed.inspect
      @logger.debug '### CoAP Received Data ###'

      # payload is not fully transmitted
      if block1[:more]
        fail 'Max Recursion' if @retry_count > 10
        return client(hostname, port, uri, method, payload, message.options)
      end

      # separate ?
      if recv_parsed.tt == :ack && recv_parsed.payload.empty? && recv_parsed.mid == mid && recv_parsed.mcode[0] == 0 && recv_parsed.mcode[1] == 0
        @logger.debug '### SEPARATE REQUEST ###'

        # wait for answer ...
        recv_data = @MySocket.receive(600, @retry_count)
        recv_parsed = CoAP.parse(recv_data[0].force_encoding('BINARY'))

        # debug functions
        @logger.debug '### CoAP SEPARAT Data ###'
        #@logger.debug recv_parsed.to_s.hexdump
        @logger.debug recv_parsed.inspect
        @logger.debug '### CoAP SEPARAT Data ###'

        if recv_parsed.tt == :con
          message = Message.new(:ack, 0, recv_parsed.mid, nil, {})
          message.options = { token: recv_parsed.options[:token] }
          @MySocket.send message.to_wire, 0
        end

        @logger.debug '### SEPARATE REQUEST END ###'
      end

      # test for more block2 payload
      block2 = Block.decode(recv_parsed.options[:block2])

      if block2[:more]
        block2[:num] += 1

        options.delete(:block1) # end block1
        options[:block2] = Block.encode_hash(block2)
        fail 'Max Recursion' if @retry_count > 50
        local_recv_parsed = client(hostname, port, uri, method, nil, options)
        recv_parsed.payload << local_recv_parsed.payload unless local_recv_parsed.nil?
      end

      # do we need to observe?
      if recv_parsed.options[:observe]
        @Observer = CoAP::Observer.new
        @Observer.observe(recv_parsed, recv_data, observe_callback, @MySocket)
      end

      # this is bad
      fail ArgumentError, 'wrong token returned' if recv_parsed.options[:token] != token # create own error class

      recv_parsed
    end
  end
end
