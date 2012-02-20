require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::ActArray do
  before do
    client = mock_client

    @actarray = Player::ActArray.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_ACTARRAY_CODE, index: 0),
      client
    )

    mock_sending_message(@actarray)
  end

  it 'should have default state' do
    @actarray.state.should eql(motor_state: 0)
    @actarray.geom.should eql(px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0)
  end

  it 'should set power state for all actuators' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [0].pack("N"))
    @actarray.power_off!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [1].pack("N"))
    @actarray.power_on!
  end

  it 'should set brakes state for all actuators' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_BRAKES, [0].pack("N"))
    @actarray.brakes_off!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_BRAKES, [1].pack("N"))
    @actarray.brakes_on!
  end

  it 'should query geometry' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_GET_GEOM)
    @actarray.query_geom
  end

  it 'should set speed config joint' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_SPEED, [0, 0.2].pack("Ng"))
    @actarray[0].set_speed_config(0.2)
  end

  it 'should set accel joint config' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_ACCEL, [1, 0.3].pack("Ng"))
    @actarray[1].set_accel_config(0.3)
  end

  it 'should set position joint' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_POS, [2, 0.4].pack("Ng"))
    @actarray[2].set_position(0.4)
  end
  
  it 'should set position for all joints' do
    data = [3, 1.0, 2.0, 3.0]
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_MULTI_POS, data.pack("Ng*"))
    @actarray.set_positions(data[1..-1])
  end

  it 'should set speed joint' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_SPEED, [3, 0.5].pack("Ng"))
    @actarray[3].set_speed(0.5)
  end
  
  it 'should set speed for all joints' do
    data = [2, 2.0, 3.0]
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_MULTI_SPEED, data.pack("Ng*"))
    @actarray.set_speeds(data[1..-1])
  end

  it 'should tell all joint go to nome' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_HOME, [-1].pack("N"))
    @actarray.go_home!
  end

  it 'should tell joint go to nome' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_HOME, [1].pack("N"))
    @actarray[1].go_home!
  end

  it 'should tell all joints to attempt to move with the given current.' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_CURRENT, [-1, 0.3].pack("Ng"))
    @actarray.set_current_all(0.3)
  end

  it 'should tell a joint to attempt to move with the given current.' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_CURRENT, [0, 0.3].pack("Ng"))
    @actarray[0].set_current(0.3)
  end
  
  it 'should set current for all joints' do
    data = [2, 2.0, 3.0]
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_MULTI_CURRENT, data.pack("Ng*"))
    @actarray.set_currents(data[1..-1])
  end

  it 'should implement Enumerable' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_ACCEL, [0, 0.3].pack("Ng"))
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_ACCEL, [1, 0.3].pack("Ng"))
    @actarray[0].set_accel_config(0.3)
    @actarray[1].set_accel_config(0.3)

    @actarray.each_with_index { |a,i| a.joint.should eql(i) }
    @actarray.count.should eql(2)
  end
  
  it 'should fill state data' do
    state = [2, 1.0, 2.0, 3.0, 4.0, PLAYER_ACTARRAY_ACTSTATE_IDLE, 
      5.0, 6.0, 7.0, 8.0, PLAYER_ACTARRAY_ACTSTATE_MOVING, 
      1]

    msg = state.pack("Ng4Ng4NN")
    @actarray.fill(
      Player::Header.from_a([0,0,PLAYER_ACTARRAY_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_ACTARRAY_DATA_STATE, 0.0, 0, msg.bytesize]),
      msg
    )

    @actarray[0].state.should eql(position: 1.0, speed: 2.0, acceleration: 3.0, current: 4.0, state: PLAYER_ACTARRAY_ACTSTATE_IDLE)
    @actarray[1].state.should eql(position: 5.0, speed: 6.0, acceleration: 7.0, current: 8.0, state: PLAYER_ACTARRAY_ACTSTATE_MOVING)
    @actarray.state[:motor_state].should eql(1)
  end
  
  it 'should get geom by request' do
   geom = [2,
     PLAYER_ACTARRAY_TYPE_LINEAR, 2.0, 0.1, 0.2, 0.3, 1.0, 2.0, 3.0, 0.0, 0.5, 1.0, 0.0, 2.0, 0, 
     PLAYER_ACTARRAY_TYPE_ROTARY, 4.0, 1.1, 1.2, 1.3, 1.1, 2.1, 3.1, 0.0, 0.5, 1.0, 1.0, 1.0, 1,
     0.5, 0.6, 0.7, 1.5, 1.6, 1.7]

    msg = geom.pack("NNgG6g5NNgG6g5NG6")
    @actarray.handle_response(
      Player::Header.from_a([0,0,PLAYER_ACTARRAY_CODE,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_ACTARRAY_REQ_GET_GEOM, 0.0, 0, msg.bytesize]),
      msg
    )

    @actarray[0].geom.should eql(type: PLAYER_ACTARRAY_TYPE_LINEAR, length: 2.0, 
                                 proll: 0.1, ppitch: 0.2, pyaw: 0.3,
                                 px: 1.0, py: 2.0, pz: 3.0, 
                                 min: 0.0, centre: 0.5, max: 1.0, home: 0.0,
                                 config_speed: 2.0, hasbreaks: 0)

    @actarray[1].geom.should eql(type: PLAYER_ACTARRAY_TYPE_ROTARY, length: 4.0, 
                                 proll: 1.1, ppitch: 1.2, pyaw: 1.3,
                                 px: 1.1, py: 2.1, pz: 3.1, 
                                 min: 0.0, centre: 0.5, max: 1.0, home: 1.0,
                                 config_speed: 1.0, hasbreaks: 1)

    @actarray.geom.should eql(px: 0.5, py: 0.6, pz: 0.7, proll: 1.5, ppitch: 1.6, pyaw: 1.7)
  end
end
