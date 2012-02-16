require File.dirname(__FILE__) + "/spec_helper"

include Player
describe Player::Position2d do
  before do
    client = mock_client
    @gripper = Player::Gripper.new(
      Player::DevAddr.new(host: 0, robot:0, interface: PLAYER_GRIPPER_CODE, index: 0),
      client
    )

    mock_sending_message(@gripper)
  end

  it 'should have default values' do
    @gripper.state.should eql(state: PLAYER_GRIPPER_STATE_OPEN, beams: 0, stored: 0)
    @gripper.geom.should eql(pose: { px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0 },
        outer_size: { sw: 0.0, sl: 0.0, sh: 0.0 },
        inner_size: { sw: 0.0, sl: 0.0, sh: 0.0 },
        number_beams: 0,
        capasity: 0
    )
  end
  
  it 'should have open? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_OPEN)
    @gripper.open?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.open?.should be_false
  end
  
  it 'should have closed? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_CLOSED)
    @gripper.closed?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.closed?.should be_false
  end

  it 'should have moving? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_MOVING)
    @gripper.moving?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.moving?.should be_false
  end

  it 'should have error? attribute' do
    @gripper.should_receive(:state).and_return(state: PLAYER_GRIPPER_STATE_ERROR)
    @gripper.error?.should be_true

    @gripper.should_receive(:state).and_return(state: 0)
    @gripper.error?.should be_false
  end

end
