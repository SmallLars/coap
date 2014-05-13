# coapmessage.rb
# Copyright (C) 2010..2013 Carsten Bormann <cabo@tzi.org>

module CoAP
  BIN = Encoding::BINARY
  UTF8 = Encoding::UTF_8

  class << self
    def empty_buffer
      ''.encode(BIN)
    end

    def invert_into_hash(a)
      a.each_with_index.each_with_object({}) { |k, h| h[k[0]] = k[1] if k[0] }
    end

    # Arrays that describe a specific option type:
    # [default value, length range, repeatable?, decoder, encoder]

    # we only care about presence or absence, always empty
    def presence_once
      [false, (0..0), false,
       ->(a) { true },
       ->(v) { v ? [''] : [] }
      ]
    end

    # token-style, goedelized in o256 here
    def o256_once(min, max, default = nil)
      [default, (min..max), false,
       ->(a) { o256_decode(a[0]) },
       ->(v) { v == default ? [] : [o256_encode(v)] }
      ]
    end

    def o256_many(min, max)   # unused
      [nil, (min..max), true,
       ->(a) { a.map { |x| o256_decode(x) } },
       ->(v) { Array(v).map { |x| o256_encode(x) } }
      ]
    end

    # vlb as in core-coap Annex A
    def uint_once(min, max, default = nil)
      [default, (min..max), false,
       ->(a) { vlb_decode(a[0]) },
       ->(v) { v == default ? [] : [vlb_encode(v)] }
      ]
    end

    def uint_many(min, max)
      [nil, (min..max), true,
       ->(a) { a.map { |x| vlb_decode(x) } },
       ->(v) { Array(v).map { |x| vlb_encode(x) } }
      ]
    end

    # Any other opaque byte sequence
    def opaq_once(min, max, default = nil)
      [default, (min..max), false,
       ->(a) { a[0] },
       ->(v) { v == default ? [] : Array(v) }
      ]
    end

    def opaq_many(min, max)
      [nil, (min..max), true,
       ->(a) { a },
       ->(v) { Array(v) }
      ]
    end

    # same, but interpreted as UTF-8
    def str_once(min, max, default = nil)
      [default, (min..max), false,
       ->(a) { a[0].force_encoding('utf-8') }, # XXX needed?
       ->(v) { v == default ? [] : Array(v) }
      ]
    end

    def str_many(min, max)
      [nil, (min..max), true,
       ->(a) { a.map { |s| s.force_encoding('utf-8') } }, # XXX needed?
       ->(v) { Array(v) }
      ]
    end
  end

  EMPTY = empty_buffer.freeze

  TTYPES = [:con, :non, :ack, :rst]
  TTYPES_I = invert_into_hash(TTYPES)
  METHODS = [nil, :get, :post, :put, :delete]
  METHODS_I = invert_into_hash(METHODS)

  # for now, keep 19
  #      TOKEN_ON = -1             # handled specially
  TOKEN_ON = 19

  # 14 => :user, default, length range, replicable?, decoder, encoder
  OPTIONS = { # name      minlength, maxlength, [default]    defined where:
    1 =>   [:if_match,       *o256_many(0, 8)],        # core-coap-12
    3 =>   [:uri_host,       *str_once(1, 255)],       # core-coap-12
    4 =>   [:etag,           *o256_many(1, 8)],        # core-coap-12 !! once in rp
    5 =>   [:if_none_match,  *presence_once],          # core-coap-12
    6 =>   [:observe,        *uint_once(0, 3)],        # core-observe-07
    7 =>   [:uri_port,       *uint_once(0, 2)],        # core-coap-12
    8 =>   [:location_path,  *str_many(0, 255)],       # core-coap-12
    11 =>  [:uri_path,       *str_many(0, 255)],       # core-coap-12
    12 =>  [:content_format, *uint_once(0, 2)],        # core-coap-12
    14 =>  [:max_age,        *uint_once(0, 4, 60)],    # core-coap-12
    15 =>  [:uri_query,      *str_many(0, 255)],       # core-coap-12
    17 =>  [:accept,         *uint_once(0, 2)],        # core-coap-18!
    TOKEN_ON =>  [:token,    *o256_once(1, 8, 0)],     # core-coap-12 -> opaq_once(1, 8, EMPTY)
    20 =>  [:location_query, *str_many(0, 255)],       # core-coap-12
    23 =>  [:block2,         *uint_once(0, 3)],        # core-block-10
    27 =>  [:block1,         *uint_once(0, 3)],        # core-block-10
    28 =>  [:size2,          *uint_once(0, 4)],        # core-block-10
    35 =>  [:proxy_uri,      *str_once(1, 1034)],      # core-coap-12
    39 =>  [:proxy_scheme,   *str_once(1, 255)],       # core-coap-13
    60 =>  [:size1,          *uint_once(0, 4)],        # core-block-10
  }
  # :user => 14, :user, def, range, rep, deco, enco
  OPTIONS_I = Hash[OPTIONS.map { |k, v| [v[0], [k, *v]] }]
  DEFAULTING_OPTIONS = Hash[OPTIONS.map { |k, v| [v[0].freeze, v[1].freeze] }
                            .select { |k, v| v }].freeze

  class << self
    def critical?(option)
      oi = OPTIONS_I[option] # this is really an option name symbol
      if oi
        option = oi[0]          # -> to option number
      end
      option.odd?
    end

    def unsafe?(option)
      oi = OPTIONS_I[option] # this is really an option name symbol
      if oi
        option = oi[0]          # -> to option number
      end
      option & 2 == 2
    end

    def no_cache_key?(option)
      oi = OPTIONS_I[option] # this is really an option name symbol
      if oi
        option = oi[0]          # -> to option number
      end
      option & 0x1e == 0x1c
    end

    # The variable-length binary (vlb) numbers defined in CoRE-CoAP Appendix A.
    def vlb_encode(n)
      # on = n
      n = Integer(n)
      fail ArgumentError, "Can't encode negative number #{n}" if n < 0
      v = empty_buffer
      while n > 0
        v << (n & 0xFF)
        n >>= 8
      end
      v.reverse!
      # warn "Encoded #{on} as #{v.inspect}"
      v
    end

    def vlb_decode(s)
      n = 0
      s.each_byte do |b|
        n <<= 8
        n += b
      end
      n
    end

    # byte strings lexicographically goedelized as numbers (one+256 coding)
    def o256_encode(num)
      str = empty_buffer
      while num > 0
        num -= 1
        str << (num & 0xFF)
        num >>= 8
      end
      str.reverse
    end

    def o256_decode(str)
      num = 0
      str.each_byte do |b|
        num <<= 8
        num += b + 1
      end
      num
    end

    # n must be 2**k
    # returns k
    def number_of_bits_up_to(n)
      Math.frexp(n - 1)[1]
    end

    def scheme_and_authority_encode(host, port)
      unless host =~ /\[.*\]/
        host = "[#{host}]" if host =~ /:/
      end
      scheme_and_authority = "coap://#{host}"
      port = Integer(port)
      scheme_and_authority << ":#{port}" unless port == 5683
      scheme_and_authority
    end

    def scheme_and_authority_decode(s)
      if s =~ %r{\A(?:coap://)((?:\[|%5B)([^\]]*)(?:\]|%5D)|([^:/]*))(:(\d+))?(/.*)?\z}i
        host = Regexp.last_match[2] || Regexp.last_match[3]       # should check syntax...
        port = Regexp.last_match[5] || 5683
        [host, port.to_i, Regexp.last_match[6]]
      end
    end

    UNRESERVED = 'A-Za-z0-9\\-\\._~' # ALPHA / DIGIT / "-" / "." / "_" / "~"
    SUB_DELIM = "!$&'()*+,;=" # "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
    PATH_UNENCODED = "#{UNRESERVED}#{SUB_DELIM}:@"
    PATH_ENCODED_RE = /[^#{PATH_UNENCODED}]/mn
    def path_encode(uri_elements)
      '/' << uri_elements.map do |el|
        el.dup.force_encoding(BIN).gsub(PATH_ENCODED_RE) { |x| '%%%02X' % x.ord }
      end.join('/')
    end

    SUB_DELIM_NO_AMP = SUB_DELIM.gsub('&', '')
    QUERY_UNENCODED = "#{UNRESERVED}#{SUB_DELIM_NO_AMP}:@/?"
    QUERY_ENCODED_RE = /[^#{QUERY_UNENCODED}]/mn
    def query_encode(query_elements)
      if query_elements.empty?
        ''
      else
        '?' << query_elements.map do |el|
          el.dup.force_encoding(BIN).gsub(QUERY_ENCODED_RE) { |x| '%%%02X' % x.ord }
        end.join('&')
      end
    end

    def percent_decode(el)
      el.gsub(/%(..)/) { Regexp.last_match[1].to_i(16).chr(BIN) }.force_encoding(UTF8)
    end

    def path_decode(path)
      a = path.split('/', -1)     # needs -1 to avoid eating trailing slashes!
      return a if a.empty?
      fail ArgumentError, 'path #{path.inspect} did not start with /' unless a[0] == ''
      return [] if a[1] == '' # special case for "/"
      a[1..-1].map do |el|
        percent_decode(el)
      end
    end

    def query_decode(query)
      return [] if query.empty?
      fail ArgumentError, 'query #{query.inspect} did not start with ?' unless query[0] == '?'
      a = query.split('&', -1).map do |el|
        el.gsub(/%(..)/) { Regexp.last_match[1].to_i(16).chr(BIN) }.force_encoding(UTF8)
      end
      a[0] = a[0][1..-1]      # remove "?"
      a
    end

    # Shortcut: CoRE::CoAP::parse == CoRE::CoAP::Message.parse
    def parse(*args)
      Message.parse(*args)
    end
  end
end
