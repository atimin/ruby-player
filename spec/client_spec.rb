require "ruby-player"

include Player::Constants
describe Player::Client do
  before do 
    @socket = mock("Socket")

    TCPSocket.stub!(:new).with("localhost", 6665).and_return(@socket) 
    @socket.stub! :flush
    Time.stub!(:now).and_return(0)
    
    @socket.should_receive(:read).with(PLAYER_IDENT_STRLEN).and_return("Mock player for 3.1-svn")

    should_send_message(
      hdr(0,0,1,0, PLAYER_MSGTYPE_REQ,PLAYER_PLAYER_REQ_DATAMODE, 0.0, 0, 4),
      [PLAYER_DATAMODE_PULL].pack("N")
    )

    @cl = Player::Client.new(host: "localhost", log_level: "debug")
  end

#  it "should raise error if connection doesn't success" do
#    lambda{ Player::Client.new(host: "localhost", post: 6666) }.should raise_error(StandardError, 
#      "connect call on [localhost:6666] failed with error [111:Connection refused]")
#  end

  it "should have close method" do
    @socket.should_receive(:closed?).and_return(false)
    @cl.closed?.should be_false

    @socket.should_receive(:closed?).and_return(true)
    @socket.should_receive(:close)
    @cl.close
    @cl.closed?.should be_true
  end

  it "should have block for connection" do
    @socket.stub!(:read)
    @socket.stub!(:write)
    @socket.should_receive(:closed?).and_return(false)
    @socket.should_receive(:close)

    Player::Client.connect(host: "localhost") do |cl|
      cl.closed?.should be_false
    end
  end

  describe "Device manage" do
    before do
      #subscribe two position2d
      should_request_data
      should_read_message(
        hdr(0, 0, PLAYER_PLAYER_CODE, 0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_PLAYER_REQ_DEV, 0.0, 0, 35),
        [0, 0, PLAYER_POSITION2D_CODE, 0, PLAYER_OPEN_MODE, 5, 5].pack("N*") + "mock"
      )

      @dev_1 = mock("dev_1")
      @cl.should_receive(:make_device).and_return(@dev_1)
      @dev_1.stub!(:addr).and_return(Player::DevAddr.decode([0, 6665, PLAYER_POSITION2D_CODE, 0].pack("N*")))

      should_read_message(
        hdr(0, 0, PLAYER_PLAYER_CODE, 0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_PLAYER_REQ_DEV, 0.0, 0, 35),
        [0, 0, PLAYER_POSITION2D_CODE, 1, PLAYER_OPEN_MODE, 5, 5].pack("N*") + "mock"
      )

      @dev_2 = mock("dev_2")
      @dev_2.stub!(:addr).and_return(Player::DevAddr.decode([0, 6665, PLAYER_POSITION2D_CODE, 1].pack("N*")))
      @cl.should_receive(:make_device).and_return(@dev_2)

      should_recive_sync
      @cl.read_all
    end

    it "should read data and fill deivice" do
      hdr, msg = 
        hdr(0, 6665, 4, 0, PLAYER_MSGTYPE_DATA, PLAYER_POSITION2D_DATA_STATE, 0.0, 0, 52),
        [0, 0, 0, 0, 0, 0, 0].pack("GGGGGGN")
      should_request_data

      should_read_message(hdr, msg)

      should_recive_sync
      @dev_1.should_receive(:fill).with(hdr, msg)

      @cl.read_all
    end

    it "should recive response and handle deivice" do
      hdr, msg = 
        hdr(0, 6665, 4, 1, PLAYER_MSGTYPE_RESP_ACK, PLAYER_POSITION2D_REQ_GET_GEOM, 0.0, 0, 72),
        ([0.0]*9).pack("G*")

      should_request_data

      should_read_message(hdr, msg)

      should_recive_sync
      @dev_2.should_receive(:handle_response).with(hdr, msg)

      @cl.read_all
    end
  end

  describe "Subscribe" do
    it "should describe to position2d" do
      #subscribe
      should_send_message(
        hdr(0, 0, 1, 0, PLAYER_MSGTYPE_REQ, PLAYER_PLAYER_REQ_DEV, 0.0, 0, 28),
        [0, 0, 4, 0, PLAYER_OPEN_MODE, 0, 0].pack("N*")
      )

      should_request_data

      should_read_message(
        hdr(16777343, 6665, PLAYER_PLAYER_CODE, 0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_PLAYER_REQ_DEV, 0.0, 0, 35),
        [0, 6665, PLAYER_POSITION2D_CODE, 0, PLAYER_OPEN_MODE, 5, 5].pack("N*") + "mock"
      )

      should_recive_sync

      pos2d = @cl.subscribe(type: "position2d")
      pos2d.addr.interface_name.should eql("position2d")
      pos2d.addr.index.should eql(0)
    end
  end

  private
  def hdr(*ary)
    Player::Header.from_a(ary)
  end

  def should_send_message(hdr, msg)
    @socket.should_receive(:write).with(hdr.encode)
    @socket.should_receive(:write).with(msg)
  end

  def should_read_message(hdr, msg)
    @socket.should_receive(:read).with(PLAYERXDR_MSGHDR_SIZE).and_return(hdr.encode)
    @socket.should_receive(:read).with(hdr.size).and_return(msg)
  end

  def should_request_data
    should_send_message(
      hdr(0, 0, 1, 0, PLAYER_MSGTYPE_REQ, PLAYER_PLAYER_REQ_DATA, 0.0, 0, 0),
      ""
    )
  end

  def should_recive_sync
    should_read_message(
      hdr(0, 0, 1, 0, PLAYER_MSGTYPE_SYNCH, 0, 0.0, 0, 0),
      ""
    )
  end
end
