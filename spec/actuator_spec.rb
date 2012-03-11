require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Actuator do
  before do
    client = mock_client

    @actarray = Player::ActArray.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_ACTARRAY_CODE, index: 0),
      client
    )

    mock_sending_message(@actarray)
    @act = @actarray[0]
  end

  it 'should have joint number' do
    @act.joint.should eql(0)
  end

  it 'should have default state' do
    @act.state.should eql(position: 0.0, speed: 0.0, acceleration: 0.0, current: 0.0, state: 0 )
    @act.geom.should eql(type: 0, length: 0.0, 
        proll: 0.0, ppitch: 0.0, pyaw: 0.0, 
        px: 0.0, py: 0.0, pz: 0.0,
        min: 0.0, centre: 0.0, max: 0.0, home: 0.0,
        config_speed: 0.0, hasbreaks: 0
    )
  end

  it 'should have #position attr' do
    @act.should_receive(:state).and_return(position: 1.2)
    @act.position.should eql(1.2)
  end

  it 'should have #speed attr' do
    @act.should_receive(:state).and_return(speed: 1.8)
    @act.speed.should eql(1.8)
  end

  it 'should have #acceleration attr' do
    @act.should_receive(:state).and_return(acceleration: 0.2)
    @act.acceleration.should eql(0.2)
  end

  it 'should have #current attr' do
    @act.should_receive(:state).and_return(current: 3.2)
    @act.current.should eql(3.2)
  end

  it 'should set speed config ' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_SPEED, [0, 0.2].pack("Ng"))
    @act.set_speed_config(0.2)
  end

  it 'should set accel config' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_ACCEL, [0, 0.3].pack("Ng"))
    @act.set_accel_config(0.3)
  end

  it 'should set position joint' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_POS, [0, 0.4].pack("Ng"))
    @act.set_position(0.4)
  end

  it 'should set speed ' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_SPEED, [0, 0.5].pack("Ng"))
    @act.set_speed(0.5)
  end

  it 'should go to nome' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_HOME, [0].pack("N"))
    @act.go_home!
  end

  it 'should be idle' do
    @act.should_receive(:state).and_return(state: 0)
    @act.idle?.should be_false

    @act.should_receive(:state).and_return(state: PLAYER_ACTARRAY_ACTSTATE_IDLE)
    @act.idle?.should be_true
  end

  it 'should be moving' do
    @act.should_receive(:state).and_return(state: 0)
    @act.moving?.should be_false

    @act.should_receive(:state).and_return(state: PLAYER_ACTARRAY_ACTSTATE_MOVING)
    @act.moving?.should be_true
  end

  it 'should be braked' do
    @act.should_receive(:state).and_return(state: 0)
    @act.braked?.should be_false

    @act.should_receive(:state).and_return(state: PLAYER_ACTARRAY_ACTSTATE_BRAKED)
    @act.braked?.should be_true
  end

  it 'should be stalled' do
    @act.should_receive(:state).and_return(state: 0)
    @act.stalled?.should be_false

    @act.should_receive(:state).and_return(state: PLAYER_ACTARRAY_ACTSTATE_STALLED)
    @act.stalled?.should be_true
  end

end

