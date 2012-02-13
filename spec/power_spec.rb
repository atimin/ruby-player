require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Power do
  before do
    client = mock_client

    @power = Player::Power.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_POWER_CODE, index: 0),
      client
    )

    mock_sending_message(@power)
  end

  it 'should have default values' do
    @power.state.should eql(valid: 0, volts: 0.0, percent: 0.0, joules: 0.0, watts: 0.0, charging: 1)
  end
end

