module CoAP
  class MySocket

    attr_writer :socket_type, :ack_timeout

    def initialize
      @logger = CoAP.logger

    end

    def connect(hostname, port)
      # hostname or ipv4/ipv6 address?
      address = IPAddr.new(hostname)
      return connect_socket(address, port)

    rescue IPAddr::InvalidAddressError
      # got a hostname, trying to resolv

      addresses = IPv6FavorResolv.getaddresses(hostname)

      raise Resolv::ResolvError if addresses.empty?

      addresses.each do |address|

        begin

          # transform to IPAddr object
          address = IPAddr.new(address.to_s)
          return connect_socket(address, port)

        rescue Errno::EHOSTUNREACH

          @logger.fatal 'Address unreachable: ' + address.to_s if $DEBUG
          # try next one if exists

        rescue Errno::ENETUNREACH

          @logger.fatal 'Net unreachable: ' + address.to_s if $DEBUG
          # try next one if exists

        end

      end
    end

    def send(data, flags)
      @socket.send(data, flags)
    end

    def receive(timeout = nil, retry_count = 0)
      timeout = @ack_timeout**(retry_count + 1) if timeout.nil? # timeout doubles

      @logger.debug @socket.peeraddr.inspect
      @logger.debug @socket.addr.inspect
      @logger.debug 'AAA Timeout: ' + timeout.to_s

      recv_data = nil
      status = Timeout.timeout(timeout) do
        recv_data = @socket.recvfrom(1024)
      end

      # pp recv_data
      recv_data
    end

    private

    def connect_socket(address, port)
      if address.ipv6?
        @socket = @socket_type.new(Socket::AF_INET6)
      else
        @socket = @socket_type.new
      end

      # TODO: Error handling connection
      @socket.connect(address.to_s, port)

      @socket
    end
  end
end
