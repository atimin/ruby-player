require "ruby-player"

include Player

describe Player::Header do
  before do
    @data = [
      0, 0, PLAYER_PLAYER_CODE, 0,
      PLAYER_MSGTYPE_REQ, PLAYER_PLAYER_REQ_DEV, 0.1, 0, 10
    ]

    @hdr = make_header
  end

  it "should have attrs" do
    @hdr.dev_addr.should == Player::DevAddr.new(host: 0, robot: 0, interface: PLAYER_PLAYER_CODE, index: 0)
    @hdr.type.should eql(PLAYER_MSGTYPE_REQ)
    @hdr.subtype.should eql(PLAYER_PLAYER_REQ_DEV)
    @hdr.size.should eql(10)
  end

  it "should have type_name" do
    @hdr.type_name.should eql("MSGTYPE_REQ")
  end

  it "should have subtype_name" do
    @hdr.subtype_name.should eql("PLAYER_REQ_DEV")
  end

  it "should comapre with other header" do
    other = Header.new
    @hdr.should_not == other

    other =  make_header
    @hdr.should == other
  end

  it "should decode itself from string " do
    Header.decode(@data.pack("NNNNNNGNN")).should == @hdr
  end

  it "should be maked form array" do
    Header.from_a(@data).should == @hdr
  end

  it "should encode string for sending" do
    @hdr.encode.should eql(@data.pack("NNNNNNGNN"))
  end

  private
  def make_header
    Player::Header.new(
      dev_addr: Player::DevAddr.new(host: @data[0], robot: @data[1], interface: @data[2], index: @data[3]),
      type: @data[4],
      subtype: @data[5],
      time: @data[6],
      seq: @data[7],
      size: @data[8]
    )
  end
end
