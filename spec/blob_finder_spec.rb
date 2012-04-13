require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::BlobFinder do
  before do
    client = mock_client

    @bf = Player::BlobFinder.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_BLOBFINDER_CODE, index: 0),
      client
    )

    mock_sending_message(@bf)
  end

  it 'should have default state' do
    @bf.state.should eql(width: 0, height: 0, blobs: [])
    @bf.color.should eql(channel: 0, rmin: 0, rmax: 0, gmin: 0, gmax: 0, bmin: 0, bmax: 0)
    @bf.imager_params.should eql(brightness: 0, contrast: 0, colormode: 0, autogain: 0)
  end

  it 'should query color' do
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_BLOBFINDER_REQ_GET_COLOR)
    @bf.query_color
  end

  it 'should set color' do
    color = [0, 1, 251, 2, 252, 3, 253] 
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_BLOBFINDER_REQ_SET_COLOR, color.pack("N*"))
    @bf.set_color(channel: 0, rmin: 1, rmax: 251, gmin: 2, gmax: 252, bmin: 3, bmax: 253)
  end
  
  it 'should set imager params' do
    params = [100, 200, 3, 1]
    should_send_message(PLAYER_MSGTYPE_REQ, PLAYER_BLOBFINDER_REQ_SET_IMAGER_PARAMS, params.pack("N*"))
    @bf.set_imager_params(brightness: 100, contrast: 200, colormode: 3, autogain: 1)
  end

  it 'should have #width attr' do
    @bf.should_receive(:state).and_return(width: 23)
    @bf.width.should eql(23)
  end

  it 'should have #height attr' do
    @bf.should_receive(:state).and_return(height: 40)
    @bf.height.should eql(40)
  end

  it 'should have #blobs attr' do
    @bf.should_receive(:state).and_return(blobs: [nil])
    @bf.blobs.should eql([nil])
  end

  it 'should fill blobs data' do
    blobs = [10, 20, 2, 2,
      0, 222, 20, 5, 4, 10, 10, 20, 20, 0.5,
      1, 111, 40, 5, 8, 20, 30, 40, 50, 2.5]
    msg = blobs.pack("NNNNN9gN9g")

    @bf.fill(
      Player::Header.from_a([0,0,PLAYER_BLOBFINDER_CODE, 0, 
                            PLAYER_MSGTYPE_DATA, PLAYER_BLOBFINDER_DATA_BLOBS, 0.0, 0, msg.bytesize]),
        msg
      )
    @bf.width.should eql(10)
    @bf.height.should eql(20)
    @bf[0].state.values.should eql(blobs[4,10])
    @bf[1].state.values.should eql(blobs[14,10])
  end

  it 'should include Enumerable' do
    @bf.state[:blobs] = Array.new(10) { |i| Blob.new(i, nil) }
    @bf.map { |b| b.should be_kind_of(Blob) }
  end

  it 'should get color config by request' do
   color = [1, 1, 2, 3, 4, 5, 6 ]

    msg = color.pack("N*")
    @bf.handle_response(
      Player::Header.from_a([0,0,PLAYER_BLOBFINDER_CODE, 0, PLAYER_MSGTYPE_RESP_ACK, PLAYER_BLOBFINDER_REQ_GET_COLOR, 0.0, 0, msg.bytesize]),
      msg
    )

    @bf.color.should eql(channel: 1, rmin: 1, rmax: 2, gmin: 3, gmax: 4, bmin: 5, bmax: 6)
  end

  it 'should not puts warn message for ACK subtypes 1,2' do  
    @bf.should_not_receive(:unexpected_message)
    (1..2).each do |i|
      @bf.handle_response(
        Player::Header.from_a([0,0,PLAYER_BLOBFINDER_CODE,0, PLAYER_MSGTYPE_RESP_ACK, i, 0.0, 0, 0]),
        "")
    end
  end
end
