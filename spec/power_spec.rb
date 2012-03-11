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
    @power.state.should eql(valid: 0, volts: 0.0, percent: 0.0, joules: 0.0, watts: 0.0, charging: 0)
  end

  it 'should have #volts attr' do
    @power.should_receive(:state).and_return(volts: 3.3)
    @power.volts.should eql(3.3)
  end
  
  it 'should have #percent attr' do
    @power.should_receive(:state).and_return(percent: 90.0)
    @power.percent.should eql(90.0)
  end
  
  it 'should have #joules attr' do
    @power.should_receive(:state).and_return(joules: 23.2)
    @power.joules.should eql(23.2)
  end
  
  it 'should have #watts attr' do
    @power.should_receive(:state).and_return(watts: 9.4)
    @power.watts.should eql(9.4)
  end

  it 'should have volts_valid? attribute' do
    @power.should_receive(:state).and_return(valid: 1)
    @power.volts_valid?.should be_true

    @power.should_receive(:state).and_return(valid: 0)
    @power.volts_valid?.should be_false
  end

  it 'should have watts_valid? attribute' do
    @power.should_receive(:state).and_return(valid: 2)
    @power.watts_valid?.should be_true

    @power.should_receive(:state).and_return(valid: 0)
    @power.watts_valid?.should be_false
  end

  it 'should have joules_valid? attribute' do
    @power.should_receive(:state).and_return(valid: 4)
    @power.joules_valid?.should be_true

    @power.should_receive(:state).and_return(valid: 0)
    @power.joules_valid?.should be_false
  end

  it 'should have percent_valid? attribute' do
    @power.should_receive(:state).and_return(valid: 8)
    @power.percent_valid?.should be_true

    @power.should_receive(:state).and_return(valid: 0)
    @power.percent_valid?.should be_false
  end

  it 'should have charging_valid? attribute' do
    @power.should_receive(:state).and_return(valid: 16)
    @power.charging_valid?.should be_true

    @power.should_receive(:state).and_return(valid: 0)
    @power.charging_valid?.should be_false
  end

  it 'should set charging policy' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POWER_REQ_SET_CHARGING_POLICY, [0,1].pack("NN"))
    @power.set_charging_policy(enable_input: false, enable_output: true)
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POWER_REQ_SET_CHARGING_POLICY, [1,0].pack("NN"))
    @power.set_charging_policy(enable_input: true, enable_output: false)
  end

  it 'should fill power state data' do
    state = {
      valid: 1, volts: 1.0, percent: 2.0, 
      joules: 3.0, watts: 4.0, charging: 1
    }
    msg = state.values.pack("NggggN")
    @power.fill(
      Player::Header.from_a([0,0,PLAYER_POWER_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_POWER_DATA_STATE, 0.0, 0, msg.bytesize]),
      msg
    )
    @power.state.should eql(state)
  end

  it 'should not puts warn message for ACK subtypes 1' do  
    @power.should_not_receive(:unexpected_message)
    @power.handle_response(
        Player::Header.from_a([0,0,PLAYER_POWER_CODE,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_POWER_REQ_SET_CHARGING_POLICY, 0.0, 0, 0]),
        "")
  end

end

