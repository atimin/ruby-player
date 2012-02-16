require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Position2d do
  before do
    client = mock_client
    @gripper = Player::Gripper.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_GRIPPER_CODE, index: 0),
      client
    )

    mock_sending_message(@gripper)
  end

  it 'should have default values' do
    @gripper.state.should eql(state: PLAYER_GRIPPER_STATE_OPEN, beams: 0, stored: 0)
    @gripper.geom.should eql(pose: { px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0 },
        outer_size: { sw: 0.0, sl: 0.0, sh: 0.0 },
        inner_size: { sw: 0.0, sl: 0.0, sh: 0.0 },
        number_beams: 0,
        capacity: 0
    )
  end
  
  it 'should have open? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_OPEN)
    @gripper.open?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.open?.should be_false
  end
  
  it 'should have closed? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_CLOSED)
    @gripper.closed?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.closed?.should be_false
  end

  it 'should have moving? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_MOVING)
    @gripper.moving?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.moving?.should be_false
  end

  it 'should have error? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_ERROR)
    @gripper.error?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.error?.should be_false
  end

  it 'should open gripper' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_OPEN)
    @gripper.open!
  end

  it 'should close gripper' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_CLOSE)
    @gripper.close!
  end

  it 'should stop gripper' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_STOP)
    @gripper.stop!
  end

  it 'should store whatever it is holding' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_STORE)
    @gripper.store!
  end

  it 'should retrieve stored object' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_RETRIEVE)
    @gripper.retrieve!
  end

  it 'should fill state data' do
    state = { state: PLAYER_GRIPPER_STATE_CLOSED, beams: 3, stored: 4 }

    msg = state.values.pack("NNN")
    @gripper.fill(
      Player::Header.from_a([0,0,PLAYER_GRIPPER_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_POWER_DATA_STATE, 0.0, 0, msg.bytesize]),
      msg
    )
    @gripper.state.should eql(state)
  end

   it 'should get geom by request' do
    geom = { pose: { px: 1.0, py: 2.0, pz: 3.0, proll: 4.0, ppitch: 5.0, pyaw: 6.0 },
        outer_size: { sw: 7.0, sl: 8.0, sh: 9.0 },
        inner_size: { sw: 10.0, sl: 11.0, sh: 12.0 },
        number_beams: 13,
        capacity: 14
    }

    msg = geom[:pose].values.pack("G*") + geom[:outer_size].values.pack("G*") + geom[:inner_size].values.pack("G*")
    msg << [geom[:number_beams], geom[:capacity]].pack("NN")
    @gripper.handle_response(
      Player::Header.from_a([0,0,4,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_GRIPPER_REQ_GET_GEOM, 0.0, 0, msg.bytesize]),
      msg
    )
    @gripper.geom.should eql(geom)
  end

  it 'should not puts warn message for ACK subtypes 1' do  
    @gripper.should_not_receive(:unexpected_message)
    @gripper.stub!(:read_geom)
    @gripper.handle_response(
        Player::Header.from_a([0,0,PLAYER_GRIPPER_CODE,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_GRIPPER_REQ_GET_GEOM, 0.0, 0, 0]),
        "")
  end

end
