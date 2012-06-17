require File.dirname(__FILE__) + "/spec_helper"

include Player
describe AIO do
  before do
    client = mock_client
    @aio = Player::AIO.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_AIO_CODE, index: 0),
      client
    )

    mock_sending_message(@aio)
  end

  it 'should have default values' do
    @aio.state.should eql(voltages: [])
  end

  it 'should have #voltages attr' do
    @aio.should_receive(:state).and_return(voltages: [0.2])
    @aio.voltages.should eql([0.2])
  end

  it 'should set output' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_AIO_CMD_STATE, [0, 0.5].pack("Ng"))
    @aio.set_voltage(0, 0.5) 
  end

  it 'should set output by #[]=' do
    should_send_message(PLAYER_MSGTYPE_CMD, PLAYER_AIO_CMD_STATE, [0, 0.5].pack("Ng"))
    @aio[0] = 0.5
  end

  it 'should fill data' do
    msg = [ 4, 4, 0.5, 1.0, 2.0, 4.0 ].pack('NNg*')
    @aio.fill(
      Player::Header.from_a([0,0,PLAYER_AIO_CODE,0, PLAYER_MSGTYPE_DATA, PLAYER_AIO_DATA_STATE, 0.0, 0, msg.bytesize]),
      msg
    ) 

    @aio.state[:voltages].should eql([0.5, 1.0, 2.0, 4.0])
  end

  it 'should implement Enumerable' do
    @aio.stub(:state).and_return(voltages: [0.2, 0.4])
    @aio.each_with_index { |v, i| v.should eql(@aio[i]) }
  end
end
