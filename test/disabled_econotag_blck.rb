# -*- encoding: utf-8 -*-
require_relative 'coap_test_helper'

ECONOTAG_PAYLOAD = Random.rand(999).to_s + 'TESTLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligul'
ECONOTAG_SHORT_PAYLOAD = Random.rand(999).to_s + 'TESTLorem ipsum'

class TestMessage < Minitest::Unit::TestCase
  def observe_tester(data, socket)
    $observe_count += 1
  end

  def test_econotag_pr_b1_b2

    client = CoAP::Client.new
    client.max_payload = 48
    answer = client.post('aaaa::60b1:10', 5683, '/r', ECONOTAG_PAYLOAD)
    assert_equal(2, answer.mcode[0])
    assert_equal(1, answer.mcode[1])
    assert_equal(ECONOTAG_PAYLOAD, answer.payload)

    client = CoAP::Client.new
    client.max_payload = 48
    answer = client.post('aaaa::60b1:10', 5683, '/r', ECONOTAG_SHORT_PAYLOAD)
    assert_equal(ECONOTAG_SHORT_PAYLOAD, answer.payload)

  end

end

# post
# mit payload und block1 oder ohne
# seperate
# block2 antwort
