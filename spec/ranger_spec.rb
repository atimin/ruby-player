require "ruby-player"

include Player::Constants
describe Player::Ranger do
  before do
    @client = mock("Client")
    @client.stub!(:write)

    @ranger = Player::Ranger.new(
      Player::DevAddr.new(host: 0, robot:0, interface: 4, index: 0),
      @client,
      :debug
    )
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

  def should_send_message(*args)
    @ranger.should_receive(:send_message)
      .with(*args)
  end

end
