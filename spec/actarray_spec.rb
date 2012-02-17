require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Power do
  before do
    client = mock_client

    @actarray = Player::ActArray.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_ACTARRAY_CODE, index: 0),
      client
    )

    mock_sending_message(@actarray)
  end

  it 'should set power state for all actuators' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [0].pack("N"))
    @actarray.turn_off!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [1].pack("N"))
    @actarray.turn_on!
  end
end
