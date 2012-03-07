require "ruby-player"

include Player

describe Player::DevAddr do
  before do
    @data = [0, 0, PLAYER_PLAYER_CODE, 0]
    @dev = make_dev_addr
  end

  it "should have attrs" do
    @dev.host.should eql(0)
    @dev.robot.should eql(0)
    @dev.interface.should eql(PLAYER_PLAYER_CODE)
    @dev.index.should eql(0)
  end

  it "should have interface_name" do
    @dev.interface_name.should eql("player")
  end

  it "should be compare with other dev addr" do
    other = DevAddr.new
    @dev.should_not == other

    other = make_dev_addr
    @dev.should == other
  end

  it "should be made from string" do
    DevAddr.decode(@data.pack("NNNN")).should == @dev
  end

  it "should encode itself to string for sending" do
    @dev.encode.should eql(@data.pack("NNNN"))
  end

  it "should convert to array" do
    @dev.to_a.should eql(@data)
  end

  private 
  def make_dev_addr
    DevAddr.new(
      host: @data[0],
      robot: @data[1],
      interface: @data[2],
      index: @data[3]
    )
  end
end
