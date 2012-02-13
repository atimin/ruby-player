require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Position2d do
  before do
    client = mock_client
    @pos2d = Player::Position2d.new(
      Player::DevAddr.new(host: 0, robot:0, interface: 4, index: 0),
      client
    )

    mock_sending_message(@pos2d)
  end

  it 'should have default values' do
    @pos2d.position.should eql(px:0.0, py:0.0, pa:0.0, vx:0.0, vy:0.0, va:0.0, stall: 0)
    @pos2d.geom.should eql(px:0.0, py:0.0, pz:0.0, proll:0.0, ppitch:0.0, pyaw:0.0, sw:0.0, sl:0.0, sh:0.0)
  end

  it 'should query geometry' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_GET_GEOM)
    @pos2d.query_geom
  end

  it 'should set motor power state' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, [0].pack("N"))
    @pos2d.turn_off!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, [1].pack("N"))
    @pos2d.turn_on!
  end

  it 'should set velocity mode' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_VELOCITY_MODE, [1].pack("N"))
    @pos2d.separate_speed_control!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_VELOCITY_MODE, [0].pack("N"))
    @pos2d.direct_speed_control!
  end

  it 'should set control mode' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_MODE, [1].pack("N"))
    @pos2d.speed_control!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_MODE, [0].pack("N"))
    @pos2d.position_control!
  end

  it 'should set odometry' do
    new_od = { px: 1.0, py: 2.0, pa: 3 }
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SET_ODOM, new_od.values.pack("GGG"))
    @pos2d.set_odometry(new_od)
  end

  it 'should reset odometry' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_RESET_ODOM)
    @pos2d.reset_odometry
  end

  it 'should set PID params for speed' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SPEED_PID, [1, 2, 3].pack("GGG"))
    @pos2d.set_speed_pid(kp: 1, ki: 2, kd: 3)
  end

  it 'should set PID params for position' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_PID, [1, 2, 3].pack("GGG"))
    @pos2d.set_position_pid(kp: 1, ki: 2, kd: 3)
  end

  it 'should set speed profile parameters' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SPEED_PROF, [1, 2].pack("GG"))
    @pos2d.set_speed_profile(speed: 1, acc: 2)
  end

  it 'should fill position data' do
    pos = {
      px: 0.0, py: 1.0, pa: 2.0,
      vx: 3.0, vy: 4.0, va: 5.0,
      stall: 1
    }
    @pos2d.fill(
      Player::Header.from_a([0,0,4,0, PLAYER_MSGTYPE_DATA, PLAYER_POSITION2D_DATA_STATE, 0.0, 0, 52]),
      pos.values.pack("GGGGGGN")
    )
    @pos2d.position.should eql(pos)
  end

  it 'should fill geom data' do
    geom = {px: 1.0, py: 2.0, pz: 3.0, proll: 4.0, ppitch: 5.0, pyaw: 6.0, sw: 7.0, sl: 8.0, sh: 9.0}
    @pos2d.fill(
      Player::Header.from_a([0,0,4,0, PLAYER_MSGTYPE_DATA, PLAYER_POSITION2D_DATA_GEOM, 0.0, 0, 72]),
      geom.values.pack("G*")
    )
    @pos2d.geom.should eql(geom)
  end

  it 'should get geom by request' do
    geom = {px: 1.0, py: 2.0, pz: 3.0, proll: 4.0, ppitch: 5.0, pyaw: 6.0, sw: 7.0, sl: 8.0, sh: 9.0}
    @pos2d.handle_response(
      Player::Header.from_a([0,0,4,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_POSITION2D_REQ_GET_GEOM, 0.0, 0, 72]),
      geom.values.pack("G*")
    )
    @pos2d.geom.should eql(geom)
  end

  it 'should set speed' do
    speed = {vx: -0.4, vy: 0.2, va: -0.1, stall: 1 }
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_VEL, speed.values.pack("GGGN"))

    @pos2d.set_speed(speed)
  end

  it 'should set speed like car' do
    speed = { vx: 0.4, a: 0.3 }
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_CAR, speed.values.pack("GG"))

    @pos2d.set_car(speed)
  end

  it 'should set speed head' do
    speed = { vx: 0.4, a: 0.3 }
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_VEL_HEAD, speed.values.pack("GG"))

    @pos2d.set_speed_head(speed)
  end

  it 'should have stop' do
    @pos2d.should_receive(:set_speed).with(vx: 0, vy: 0, va: 0)
    @pos2d.stop!
  end

  it 'should not puts warn message for ACK subtypes 2..9' do  
    @pos2d.should_not_receive(:unexpected_message)
    (2..9).each do |i|
      @pos2d.handle_response(
        Player::Header.from_a([0,0,4,0, PLAYER_MSGTYPE_RESP_ACK, i, 0.0, 0, 0]),
        "")
    end
  end

end
