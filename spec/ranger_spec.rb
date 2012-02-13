require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Ranger do
  before do
    client = mock_client
    @ranger = Player::Ranger.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_RANGER_CODE, index: 0),
      @client
    )

    mock_sending_message(@ranger)
  end

  it 'should have default values' do
    @ranger.rangers.should eql([])
    @ranger.intensities.should eql([])
    @ranger.geom.should eql(px:0.0, py:0.0, pz:0.0, proll:0.0, ppitch:0.0, pyaw:0.0, sw:0.0, sl:0.0, sh:0.0, sensors: [])
    @ranger.config.should eql(min_angle: 0.0, max_angle: 0.0, angular_res: 0.0, min_range: 0.0, max_range: 0.0, range_res: 0.0, frequecy: 0.0)
  end

  it 'should query geometry' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_GET_GEOM)
    @ranger.query_geom
  end

  it 'should set power state' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_POWER, [1].pack("N"))
    @ranger.turn_on!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_POWER, [0].pack("N"))
    @ranger.turn_off!
  end

  it 'should  enable\disable intensity ' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_INTNS, [1].pack("N"))
    @ranger.intensity_enable!

    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_INTNS, [0].pack("N"))
    @ranger.intensity_disable!
  end

  it 'should set config' do
     config  = { 
        min_angle:    0.1,
        max_angle:    0.9,            
        angular_res:  0.01,            
        min_range:    2.0,
        max_range:    4.0,
        range_res:    1.0,
        frequecy:     60.0 
     }

      msg = config.values.pack("G*")
      should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_SET_CONFIG, msg)
      @ranger.set_config(config)
   end

  it 'should query config' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_GET_CONFIG)
    @ranger.query_config
  end

  it 'should fill rangers data' do
    rangers = [0.4, 0.3, 0.2, 0.1]
    @ranger.fill(
      Player::Header.from_a([0,0,PLAYER_RANGER_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_RANGER_DATA_RANGE, 0.0, 0, 20]),
      ([4,0] + rangers).pack("NNG*")
    )
    @ranger.rangers.should eql(rangers)
  end

  it 'should fill intensities data' do
    intns = [0.1, 0.2, 0.3, 0.4]
    @ranger.fill(
      Player::Header.from_a([0,0,PLAYER_RANGER_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_RANGER_DATA_INTNS, 0.0, 0, 20]),
      ([4,0] + intns).pack("NNG*")
    )
   
    @ranger.intensities.should eql(intns)
  end

  it 'should fill geom data' do
    geom = [1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0,
      2, 0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0,  2.0, 1.0, 1.0, 0.0, 0.0, -1.0,
      2, 0, 0.5, 0.5, 0.5,  0.5, 0.5, 0.5]

    msg = geom.pack("G9NNG12NNG6")
    @ranger.fill(
      Player::Header.from_a([0,0,PLAYER_RANGER_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_RANGER_DATA_GEOM, 0.0, 0, msg.bytesize]),
      msg
    )

    @ranger.geom.should eql(
      px: 1.0, py: 1.0, pz: 1.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0, sw: 2.0, sl: 2.0, sh: 2.0,
      sensors: [
        { px: 1.0, py: 1.0, pz: 1.0, proll: 0.0, ppitch: 0.0, pyaw: 1.0, sw: 0.5, sl: 0.5, sh: 0.5 },
        { px: 2.0, py: 1.0, pz: 1.0, proll: 0.0, ppitch: 0.0, pyaw: -1.0, sw: 0.5, sl: 0.5, sh: 0.5 }
      ]
    )
  end

  it 'should get geom by request' do
   geom = [1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0,
      2, 0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0,  2.0, 1.0, 1.0, 0.0, 0.0, -1.0,
      2, 0, 0.5,
      0.5, 0.5,  0.5, 0.5, 0.5]

    msg = geom.pack("G9NNG12NNG6")
    @ranger.handle_response(
      Player::Header.from_a([0,0,PLAYER_RANGER_CODE,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_RANGER_REQ_GET_GEOM, 0.0, 0, msg.bytesize]),
      msg
    )

    @ranger.geom.should eql(
      px: 1.0, py: 1.0, pz: 1.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0, sw: 2.0, sl: 2.0, sh: 2.0,
      sensors: [
        { px: 1.0, py: 1.0, pz: 1.0, proll: 0.0, ppitch: 0.0, pyaw: 1.0, sw: 0.5, sl: 0.5, sh: 0.5 },
        { px: 2.0, py: 1.0, pz: 1.0, proll: 0.0, ppitch: 0.0, pyaw: -1.0, sw: 0.5, sl: 0.5, sh: 0.5 }
      ]
    )
  end

  it 'should get config  by request' do
   config  = { 
    min_angle:    0.1,
    max_angle:    0.9,            
    angular_res:  0.01,            
    min_range:    2.0,
    max_range:    4.0,
    range_res:    1.0,
    frequecy:     60.0 
   }

    msg = config.values.pack("G*")
    @ranger.handle_response(
      Player::Header.from_a([0,0,PLAYER_RANGER_CODE,0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_RANGER_REQ_GET_CONFIG, 0.0, 0, msg.bytesize]),
      msg
    )

    @ranger.config.should eql(config)
  end

  it 'should not puts warn message for ACK subtypes 2..4' do  
    @ranger.should_not_receive(:unexpected_message)
    (2..4).each do |i|
      @ranger.handle_response(
        Player::Header.from_a([0,0,4,0, PLAYER_MSGTYPE_RESP_ACK, i, 0.0, 0, 0]),
        "")
    end
  end
end
