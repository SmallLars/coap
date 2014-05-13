module CoAP
  class Observer
    MAX_OBSERVE_OPTION_VALUE = 8_388_608

    def initialize
      @logger = CoAP.logger

      @retry_count = 0
    end

    def observe(recv_parsed, recv_data, observe_callback, mySocket)
      observe_number = recv_parsed.options[:observe]
      observe_callback.call(recv_parsed, recv_data)

      loop do
        begin # todo fix this
          recv_data = mySocket.receive(60, @retry_count)
        rescue Timeout::Error
         @retry_count = 0
         @logger.error 'Observe Timeout'
        end

        recv_parsed = CoAP.parse(recv_data[0].force_encoding('BINARY'))

        if recv_parsed.tt == :con
          message = Message.new(:ack, 0, recv_parsed.mid, nil, {})
          mySocket.send message.to_wire, 0
        end

        if recv_parsed.options[:observe] &&
        ((recv_parsed.options[:observe] > observe_number && recv_parsed.options[:observe] - observe_number < MAX_OBSERVE_OPTION_VALUE) ||
        (recv_parsed.options[:observe] < observe_number && observe_number - recv_parsed.options[:observe] > MAX_OBSERVE_OPTION_VALUE))

          observe_callback.call(recv_parsed, recv_data)

        end

      end
    end
  end
end
