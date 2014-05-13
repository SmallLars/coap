# -*- encoding: utf-8 -*-
require_relative 'coap_test_helper'

class TestMessage < Minitest::Unit::TestCase
  def test_number_of_bits_up_to
    assert_equal 0, CoAP.number_of_bits_up_to(1)
    assert_equal 4, CoAP.number_of_bits_up_to(16)
    assert_equal 5, CoAP.number_of_bits_up_to(32)
    assert_equal 7, CoAP.number_of_bits_up_to(128)
  end

  def test_query_encode
    assert_equal '', CoAP.query_encode([])
    assert_equal '?', CoAP.query_encode([''])
    assert_equal '?foo', CoAP.query_encode(['foo'])
    assert_equal '?foo&bar', CoAP.query_encode(%w(foo bar))
    assert_equal '?f.o&b-r', CoAP.query_encode(['f.o', 'b-r'])
    assert_equal '?f(o&b)r', CoAP.query_encode(['f(o', 'b)r'])
    assert_equal '?foo&b/r', CoAP.query_encode(['foo', 'b/r'])
    assert_equal '?foo&b%26r', CoAP.query_encode(['foo', 'b&r'])
    assert_equal '?f%C3%B8o&b%C3%A4r', CoAP.query_encode(['føo', 'bär'])
  end

  # XXX: now properly checks for trailing slashes, how much trouble?
  def test_path_decode
    assert_equal [], CoAP.path_decode('/')
    assert_equal ['foo'], CoAP.path_decode('/foo')
    assert_equal ['foo', ''], CoAP.path_decode('/foo/') # confusing!
    assert_equal %w(foo bar), CoAP.path_decode('/foo/bar')
    assert_equal ['f.o', 'b-r'], CoAP.path_decode('/f.o/b-r')
    assert_equal ['f(o', 'b)r'], CoAP.path_decode('/f(o/b)r')
    assert_equal ['foo', 'b/r'], CoAP.path_decode('/foo/b%2Fr')
    assert_equal ['foo', 'b&r'], CoAP.path_decode('/foo/b&r')
    assert_equal ['føo', 'bär'], CoAP.path_decode('/f%C3%B8o/b%C3%A4r')
  end

  # XXX: now checks for trailing ampersands
  def test_query_decode
    assert_equal [], CoAP.query_decode('')
    assert_equal [''], CoAP.query_decode('?')
    assert_equal ['foo'], CoAP.query_decode('?foo')
    assert_equal ['foo', ''], CoAP.query_decode('?foo&')
    assert_equal %w(foo bar), CoAP.query_decode('?foo&bar')
    assert_equal ['f.o', 'b-r'], CoAP.query_decode('?f.o&b-r')
    assert_equal ['f(o', 'b)r'], CoAP.query_decode('?f(o&b)r')
    assert_equal ['foo', 'b/r'], CoAP.query_decode('?foo&b/r')
    assert_equal ['foo', 'b&r'], CoAP.query_decode('?foo&b%26r')
    assert_equal ['føo', 'bär'], CoAP.query_decode('?f%C3%B8o&b%C3%A4r')
  end

  def test_scheme_and_authority_encode
    assert_equal 'coap://foo.bar:4711', CoAP.scheme_and_authority_encode('foo.bar', 4711)
    assert_equal 'coap://foo.bar:4711', CoAP.scheme_and_authority_encode('foo.bar', '4711')
    assert_raises ArgumentError do
      CoAP.scheme_and_authority_encode('foo.bar', 'baz')
    end
    assert_equal 'coap://bar.baz', CoAP.scheme_and_authority_encode('bar.baz', 5683)
    assert_equal 'coap://bar.baz', CoAP.scheme_and_authority_encode('bar.baz', '5683')
  end

  def test_scheme_and_authority_decode
    assert_equal ['foo.bar', 4711, nil], CoAP.scheme_and_authority_decode('coap://foo.bar:4711')
    assert_equal ['foo.bar', 5683, nil], CoAP.scheme_and_authority_decode('coap://foo.bar')
    assert_equal ['foo:bar', 4711, nil], CoAP.scheme_and_authority_decode('coap://[foo:bar]:4711')
    assert_equal ['foo:bar', 5683, nil], CoAP.scheme_and_authority_decode('coap://%5Bfoo:bar%5D')
  end

  def test_coap_message
    input = "\x44\x02\x12\xA0abcd\x41A\x7B.well-known\x04core\x0D\x04rhabarbersaftglas\xFFfoobar".force_encoding('BINARY')
    output = CoAP.parse(input)
    w = output.to_wire
    assert_equal input, w
  end

# XXX TODO add token tests

  def test_fenceposting
    m = CoAP::Message.new(:con, :get, 4711, 'Hello', {})
    m.options = { max_age: 987_654_321, if_none_match: true }
    me = m.to_wire
    m2 = CoAP.parse(me)
    m.options = CoAP::DEFAULTING_OPTIONS.merge(m.options)
    assert_equal m2, m
  end

  def test_fenceposting2
    m = CoAP::Message.new(:con, :get, 4711, 'Hello', {})
    m.options = { 4711 => ['foo'], 256 => ['bar'] }
    me = m.to_wire
    m2 = CoAP.parse(me)
    m.options = CoAP::DEFAULTING_OPTIONS.merge(m.options)
    assert_equal m2, m
  end

  def test_emptypayload
    m = CoAP::Message.new(:con, :get, 4711, '', {})
    m.options = { 4711 => ['foo'], 256 => ['bar'], 65_535 => ['abc' * 100] }
    me = m.to_wire
    m2 = CoAP.parse(me)
    m.options = CoAP::DEFAULTING_OPTIONS.merge(m.options)
    assert_equal m2, m
  end

  def test_option_numbers
    (0...65_536).each do |on|
      unless CoAP::OPTIONS[on] # those might have special semantics
        m = CoAP::Message.new(:con, :get, 4711, 'Hello', {})
        m.options = { on => [''] }
        me = m.to_wire
        m2 = CoAP.parse(me)
        m.options = CoAP::DEFAULTING_OPTIONS.merge(m.options)
        assert_equal m2, m
      end
    end
  end

  def test_option_lengths
    (0...1024).each do |ol|
      m = CoAP::Message.new(:con, :get, 4711, 'Hello', {})
      m.options = { 99 => ['x' * ol] }
      me = m.to_wire
      m2 = CoAP.parse(me)
      m.options = CoAP::DEFAULTING_OPTIONS.merge(m.options)
      assert_equal m2, m
    end
  end
end
