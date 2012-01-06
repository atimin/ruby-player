require "ruby-player"

describe Player::Client do
  before do 
    @cl = Player::Client.new("localhost")
  end

  it "should raise error if connection doesn't success" do
    lambda{ Player::Client.new("localhost", 6666) }.should raise_error(StandardError, 
      "connect call on [localhost:6666] failed with error [111:Connection refused]")
  end

  it "should have close method" do
    @cl.closed?.should be_false
    @cl.close
    @cl.closed?.should be_true
  end

  it "should have block for connection" do
    @cl.close
    Player::Client.connect("localhost") do |cl|
      @cl = cl
      @cl.closed?.should be_false
    end

    @cl.closed?.should be_true
  end

  after do
    @cl.close unless @cl.closed?
  end
end
