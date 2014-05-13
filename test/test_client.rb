# -*- encoding: utf-8 -*-
require_relative 'coap_test_helper'

# BAD: tests rely on working connection to coap.me (!)
# TODO: rewrite tests with local coap server
# test
$observe_count = 0
PAYLOAD = Random.rand(999).to_s + 'TESTLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nuncLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nuncTEST'

PAYLOAD_SONDERZEICHEN = Random.rand(999).to_s + 'TESTLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla 超大航母 consequat massa quis enim. Donec pede justoidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nuncTEST'


class TestMessage < Minitest::Unit::TestCase
  def observe_tester(data, socket)
    $observe_count += 1
  end

  def test_client_get_v4_v6_hostname
    # client = CoAP::Client.new
    # answer = client.get('2001:638:708:30da:219:d1ff:fea4:abc5', 5683, '/hello')
    # assert_equal(2,answer.mcode[0])
    # assert_equal(5,answer.mcode[1])
    # assert_equal('world',answer.payload)

    client = CoAP::Client.new
    answer = client.get('coap.me', 5683, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

    client = CoAP::Client.new
    answer = client.get('134.102.218.16', 5683, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)
  end

  def test_client_404
    # 404
    client = CoAP::Client.new
    answer = client.get('coap.me', 5683, '/hello-this-does-not-exist')
    assert_equal(4, answer.mcode[0])
    assert_equal(4, answer.mcode[1])
    assert_equal('Not found', answer.payload)
  end

  def test_multi_request

    x = Time.now
    client = CoAP::Client.new
    assert_raises RuntimeError do
      answer = client.get('192.0.2.1', 5683, '/hello')
    end

    x = Time.now
    assert_raises RuntimeError do
      answer = client.get('192.0.2.1', 5683, '/hello')
    end
    duration = Time.now - x
    #assert_operator duration, :>, 0
    #assert_operator duration, :<, 5

  end

  def test_client_connection_dns_problems

    # invalid hostname
    client = CoAP::Client.new
    assert_raises Resolv::ResolvError do
      client.get('coapunknown.mexyz', 5683, '/hello')
    end

  end

  def test_max_retransmit_ack_timeout

    client = CoAP::Client.new(256, 0, 30)
    duration = 0
    x = Time.now
    assert_raises RuntimeError do
      answer = client.get('bongo.xmorpheus.de', 1194, '/hello')
    end
    duration = Time.now - x
    assert_operator duration, :>, 25
    assert_operator duration, :<, 35

    client = CoAP::Client.new(256, 1, 30)
    duration = 0
    x = Time.now
    assert_raises RuntimeError do
      answer = client.get('bongo.xmorpheus.de', 1194, '/hello')
    end
    duration = Time.now - x
    assert_operator duration, :>, 55
    assert_operator duration, :<, 110

  end

  def test_client_arguments
    # wrong port
    client = CoAP::Client.new
    assert_raises Errno::ECONNREFUSED do
      client.get('coap.me', 15_683, '/hello')
    end

    # empty uri
    client = CoAP::Client.new
    assert_raises ArgumentError do
      answer = client.get('coap.me', 5683, '')
    end

    # empty hostname
    client = CoAP::Client.new
    assert_raises ArgumentError do
      answer = client.get('', 15_683, '/hello')
    end

    # missing port
    client = CoAP::Client.new
    assert_raises ArgumentError do
      answer = client.get('coap.me', nil, '/hello')
    end

    # string port
    client = CoAP::Client.new
    assert_raises ArgumentError do
      answer = client.get('coap.me', 'i m a sring', '/hello')
    end

    # empty payload
    client = CoAP::Client.new
    @suchEmpty = ''
    assert_raises ArgumentError do
      answer = client.post('coap.me', 5683, '/large-create', @suchEmpty)
    end

  end

  def test_client_by_url
    client = CoAP::Client.new
    answer = client.get_by_url('coap://coap.me:5683/hello')
    assert_equal('world', answer.payload)

    # broken url
    client = CoAP::Client.new
    assert_raises ArgumentError do
      answer = client.get_by_url('coap:/#/coap.me:5683/hello')
    end
  end

  # need to test payload

  def test_client_post
    client = CoAP::Client.new
    answer = client.post('coap.me', 5683, '/test', 'TD_COAP_CORE_04')
    assert_equal(2, answer.mcode[0])
    assert_equal(1, answer.mcode[1])
    assert_equal('POST OK', answer.payload)
  end

    # basic test put
  def test_client_put
    client = CoAP::Client.new
    answer = client.put('coap.me', 5683, '/test', 'TD_COAP_CORE_03')
    assert_equal(2, answer.mcode[0])
    assert_equal(4, answer.mcode[1])
    assert_equal('PUT OK', answer.payload)
  end

  def test_client_delete
    client = CoAP::Client.new
    answer = client.delete('coap.me', 5683, '/test')
    assert_equal(2, answer.mcode[0])
    assert_equal(2, answer.mcode[1])
    assert_equal('DELETE OK', answer.payload)
  end

  def test_client_sönderzeichen
    client = CoAP::Client.new
    answer = client.get_by_url('coap://coap.me/bl%C3%A5b%C3%A6rsyltet%C3%B8y')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('Übergrößenträger = 特大の人 = 超大航母', answer.payload.force_encoding('utf-8'))
  end

  def test_client_custom_call
    client = CoAP::Client.new
    answer = client.custom('coap://coap.me/bl%C3%A5b%C3%A6rsyltet%C3%B8y', 'get')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('Übergrößenträger = 特大の人 = 超大航母', answer.payload.force_encoding('utf-8'))
  end

  def test_multi_request_without_hostname_port

    client = CoAP::Client.new
    client.hostname = 'coap.me'
    client.port = 5683
    answer = client.get(nil, nil, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

    answer = client.get(nil, nil, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

    answer = client.get(nil, nil, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

    client = CoAP::Client.new
    answer = client.get('coap.me', 5683, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

    answer = client.get(nil, nil, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

    answer = client.get(nil, nil, '/hello')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('world', answer.payload)

  end

  def test_initialize
    client = CoAP::Client.new(16, 4, 2, 'coap.me', 5683)
    answer = client.get(nil, nil, '/large')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal(%Q'\n     0                   1                   2                   3\n    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |Ver| T |  TKL  |      Code     |          Message ID           |\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |   Token (if any, TKL bytes) ...\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |   Options (if any) ...\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |1 1 1 1 1 1 1 1|    Payload (if any) ...\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n\n[...]\n\n   Token Length (TKL):  4-bit unsigned integer.  Indicates the length of\n      the variable-length Token field (0-8 bytes).  Lengths 9-15 are\n      reserved, MUST NOT be sent, and MUST be processed as a message\n      format error.\n\n   Code:  8-bit unsigned integer, split into a 3-bit class (most\n      significant bits) and a 5-bit detail (least significant bits),\n      documented as c.dd where c is a digit from 0 to 7 for the 3-bit\n      subfield and dd are two digits from 00 to 31 for the 5-bit\n      subfield.  The class can indicate a request (0), a success\n      response (2), a client error response (4), or a server error\n      response (5).  (All other class values are reserved.)  As a\n      special case, Code 0.00 indicates an Empty message.  In case of a\n      request, the Code field indicates the Request Method; in case of a\n      response a Response Code.  Possible values are maintained in the\n      CoAP Code Registries (Section 12.1).  The semantics of requests\n      and responses are defined in Section 5.\n\n', answer.payload)
  end

  def test_client_separate
    client = CoAP::Client.new
    answer = client.get('coap.me', 5683, '/separate')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal('That took a long time', answer.payload)
  end

  def test_client_observe
    # basic observe test
    client = CoAP::Client.new

    t1 = Thread.new do
      answer = client.observe('vs0.inf.ethz.ch', 5683, '/obs', method(:observe_tester))
    end
    sleep(10)
    t1.kill

    assert_operator $observe_count, :>, 2
  end

  def test_client_block2
    # blockwise transfer (block2)
    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.get('coap.me', 5683, '/large')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal(%Q'\n     0                   1                   2                   3\n    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |Ver| T |  TKL  |      Code     |          Message ID           |\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |   Token (if any, TKL bytes) ...\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |   Options (if any) ...\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n   |1 1 1 1 1 1 1 1|    Payload (if any) ...\n   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n\n[...]\n\n   Token Length (TKL):  4-bit unsigned integer.  Indicates the length of\n      the variable-length Token field (0-8 bytes).  Lengths 9-15 are\n      reserved, MUST NOT be sent, and MUST be processed as a message\n      format error.\n\n   Code:  8-bit unsigned integer, split into a 3-bit class (most\n      significant bits) and a 5-bit detail (least significant bits),\n      documented as c.dd where c is a digit from 0 to 7 for the 3-bit\n      subfield and dd are two digits from 00 to 31 for the 5-bit\n      subfield.  The class can indicate a request (0), a success\n      response (2), a client error response (4), or a server error\n      response (5).  (All other class values are reserved.)  As a\n      special case, Code 0.00 indicates an Empty message.  In case of a\n      request, the Code field indicates the Request Method; in case of a\n      response a Response Code.  Possible values are maintained in the\n      CoAP Code Registries (Section 12.1).  The semantics of requests\n      and responses are defined in Section 5.\n\n', answer.payload)
  end

  def test_client_block1
    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.post('coap.me', 5683, '/large-create', PAYLOAD)
    assert_equal(2, answer.mcode[0])
    assert_equal(1, answer.mcode[1])

    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.get('coap.me', 5683, '/large-create')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal(PAYLOAD, answer.payload)

    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.post('coap.me', 5683, '/large-create', PAYLOAD_SONDERZEICHEN)
    assert_equal(2, answer.mcode[0])
    assert_equal(1, answer.mcode[1])

    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.get('coap.me', 5683, '/large-create')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal(PAYLOAD_SONDERZEICHEN, answer.payload.force_encoding('utf-8'))

    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.put('coap.me', 5683, '/large-update', PAYLOAD)
    assert_equal(2, answer.mcode[0])
    assert_equal(4, answer.mcode[1])

    client = CoAP::Client.new
    client.max_payload = 512
    answer = client.get('coap.me', 5683, '/large-update')
    assert_equal(2, answer.mcode[0])
    assert_equal(5, answer.mcode[1])
    assert_equal(PAYLOAD, answer.payload)
  end
end
