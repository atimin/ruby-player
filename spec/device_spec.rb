require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Device do
  before do
    @dev_addr = DevAddr.new(interface: PLAYER_POSITION2D_CODE)
    @client = mock_client
    @dev = Device.new(@dev_addr, @client)
  end

  it "should have addr" do
    @dev.addr.should == @dev_addr
  end

  it "should send message" do
    Time.stub!(:now).and_return(0)
    @client.should_receive(:send_message_with_hdr).with(
      Header.new(
        dev_addr: @dev_addr,
        type: PLAYER_MSGTYPE_REQ,
        subtype: PLAYER_POSITION2D_REQ_MOTOR_POWER,
        size: 4
      ), [0].pack("N")
    )
    @dev.send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, "\x0\x0\x0\x0")
  end
end
