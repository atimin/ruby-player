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
    @bf.state.should eql(width: 0.0, height: 0.0, blobs: [])
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

end
