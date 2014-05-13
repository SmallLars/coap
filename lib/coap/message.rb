# coapmessage.rb
# Copyright (C) 2010..2013 Carsten Bormann <cabo@tzi.org>

module CoAP
  class Message < Struct.new(:ver, :tt, :mcode, :mid, :options, :payload)
    def initialize(*args)     # convenience: .new(tt?, mcode?, mid?, payload?, hash)
      if args.size < 6
        h = args.pop.dup
        tt = h.delete(:tt) || args.shift
        mcode = h.delete(:mcode) || args.shift
        case mcode
        when Integer then mcode = METHODS[mcode] || [mcode >> 5, mcode & 0x1f]
        when Float then mcode = [mcode.to_i, (mcode * 100 % 100).round] # accept 2.05 and such
        end
        mid = h.delete(:mid) || args.shift
        payload = h.delete(:payload) || args.shift || EMPTY # no payload = empty payload
        fail 'CoRE::CoAPMessage.new: hash or all args' unless args.empty?
        super(1, tt, mcode, mid, h, payload)
      else
        super
      end
    end

    def mcode_readable
      case mcode
      when Array
        "#{mcode[0]}.#{"%02d" % mcode[1]}"
      else
        mcode.to_s
      end
    end

    def self.deklausify(d, dpos, len)
      case len
      when 0..12
        [len, dpos]
      when 13
        [d.getbyte(dpos) + 13, dpos += 1]
      when 14
        [d.byteslice(dpos, 2).unpack('n')[0] + 269, dpos += 2]
      else
        fail "[#{d.inspect}] Bad delta/length nibble #{len} at #{dpos}"
      end
    end

    def self.parse(d)
      # dpos keeps our current position in parsing d
      b1, mcode, mid = d.unpack('CCn'); dpos = 4
      toklen = b1 & 0xf
      token = d.byteslice(dpos, toklen); dpos += toklen
      b1 >>= 4
      tt = TTYPES[b1 & 0x3]
      b1 >>= 2
      fail ArgumentError, "unknown CoAP version #{b1}" unless b1 == 1
      mcode = METHODS[mcode] || [mcode >> 5, mcode & 0x1F]

      # collect options
      onumber = 0             # current option number
      options = Hash.new { |h, k| h[k] = [] }
      dlen = d.bytesize
      while dpos < dlen
        tl1 = d.getbyte(dpos); dpos += 1
        fail ArgumentError, "option is not there at #{dpos} with oc #{orig_numopt}" unless tl1 # XXX

        break if tl1 == 0xff

        odelta, dpos = deklausify(d, dpos, tl1 >> 4)
        olen, dpos = deklausify(d, dpos, tl1 & 0xF)

        onumber += odelta

        if dpos + olen > dlen
          fail ArgumentError, "#{olen}-byte option at #{dpos} -- not enough data in #{dlen} total"
        end

        oval = d.byteslice(dpos, olen); dpos += olen
        options[onumber] << oval
      end

      options[TOKEN_ON] = [token] if token != ''

      # d.bytesize = more than all the rest...
      decode_options_and_put_together(b1, tt, mcode, mid, options,
                                      d.byteslice(dpos, d.bytesize))
    end

    def self.decode_options_and_put_together(b1, tt, mcode, mid, options, payload)
      # check and decode option values
      decoded_options = DEFAULTING_OPTIONS.dup
      options.each_pair do |k, v|
        if oinfo = OPTIONS[k]
          oname, _, minmax, repeatable, decoder, _ = *oinfo
          repeatable or v.size <= 1 or
            fail ArgumentError, "repeated unrepeatable option #{oname}"
          v.each do |v1|
            unless minmax === v1.bytesize
              fail ArgumentError, "#{v1.inspect} out of #{minmax} for #{oname}"
            end
          end
          decoded_options[oname] = decoder.call(v)
        else
          decoded_options[k] = v # we don't know what that is -- keep it in raw
        end
      end

      new(b1, tt, mcode, mid, Hash[decoded_options], payload) # XXX: why Hash[] again?
    end

    def prepare_options
      prepared_options = {}
      options.each do |k, v|
        # puts "k = #{k.inspect}, oinfo_i = #{OPTIONS_I[k].inspect}"
        if oinfo_i = OPTIONS_I[k]
          onum, oname, defv, minmax, rep, _, encoder = *oinfo_i
          prepared_options[onum] = a = encoder.call(v)
          rep or a.size <= 1 or fail "repeated option #{oname} #{a.inspect}"
          a.each do |v1|
            unless minmax === v1.bytesize
              fail ArgumentError, "#{v1.inspect} out of #{minmax} for #{oname}"
            end
          end
        else
          fail ArgumentError, "#{k.inspect}: unknown option" unless Integer === k
          prepared_options[k] = Array(v) # store raw option
        end
      end
      prepared_options
    end

    def klausify(n)
      if n < 13
        [n, '']
      else
        n -= 13
        if n < 256
          [13, [n].pack('C')]
        else
          [14, [n - 256].pack('n')]
        end
      end
    end

    def to_wire
      # check and encode option values
      prepared_options = prepare_options
      # puts "prepared_options: #{prepared_options}"

      token = (prepared_options.delete(TOKEN_ON) || [nil])[0] || ''
      # puts "TOKEN: #{token.inspect}" unless token

      b1 = 0x40 | TTYPES_I[tt] << 4 | token.bytesize
      b2 = METHODS_I[mcode] || (mcode[0] << 5) + mcode[1]
      result = [b1, b2, mid].pack('CCn')
      result << token

      # stuff options in packet
      onumber = 0
      num_encoded_options = 0

      prepared_options.keys.sort.each do |k|
        fail "Bad Option Type #{k.inspect}" unless Integer === k && k >= 0
        a = prepared_options[k]
        a.each do |v|
          # result << frob(k, v)
          odelta = k - onumber
          onumber = k

          odelta1, odelta2 = klausify(odelta)
          odelta1 <<= 4

          length1, length2 = klausify(v.bytesize)
          result << [odelta1 | length1].pack('C')
          result << odelta2
          result << length2
          result << v.dup.force_encoding(BIN)         # value
        end

      end

      if payload != ''
        result << 0xFF
        result << payload.dup.force_encoding(BIN)
      end
      result
    end
  end
end
