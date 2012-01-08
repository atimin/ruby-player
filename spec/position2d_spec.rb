require "ruby-player"

describe Player::Position2d do
  before do
    @cl = Player::Client.connect("localhost") 
    @pos2d = @cl[:position2d, 0]
    @pos2d.stop
    @cl.read
  end

  it 'should set odometry' do
    pending "Don't work with Player/Stage"
    new_od = { px: 1.0, py: 2.0, pa: 3 }
    @pos2d.set_odometry(new_od)
    @pos2d.reset_odometry
    
    sleep(1.0)
    @cl.read

    @pos2d.odometry.should eql(new_od)
  end

  it 'should move' do
    pos = @pos2d.odometry
    speed = {vx: -0.4, vy: 0.2, va: -0.1 }
    @pos2d.set_speed(speed)

    sleep(1.1)
    @cl.read
    @pos2d.speed.should eq(speed)

    #change position
    @pos2d.odometry[:px].should be_within(0.1).of(pos[:px] + speed[:vx]*Math.cos(pos[:pa]) - speed[:vy]*Math.sin(pos[:pa]))
    @pos2d.odometry[:py].should be_within(0.1).of(pos[:py] + speed[:vx]*Math.sin(pos[:pa]) + speed[:vy]*Math.cos(pos[:pa]))
    Math.sin(@pos2d.odometry[:pa]).should be_within(0.1).of(Math.sin(pos[:pa] + speed[:va]))
  end


  it 'should move like car' do
    pos = @pos2d.odometry
    speed = { vx: 0.4, a: 0.3 }
    @pos2d.set_car(speed)

    sleep(1.1)
    @cl.read
    @pos2d.speed.should eq(vx: 0.4, vy: 0.0, va: 0.3)

    #change position
    @pos2d.odometry[:px].should be_within(0.1).of(pos[:px] + speed[:vx]*Math.cos(pos[:pa]))
    @pos2d.odometry[:py].should be_within(0.1).of(pos[:py] + speed[:vx]*Math.sin(pos[:pa]))
    Math.sin(@pos2d.odometry[:pa]).should be_within(0.1).of(Math.sin(pos[:pa] + speed[:a]))
  end

  it 'should have stop' do
    # Move robot
    @pos2d.set_speed(vx: 1.0, vy: 0.5, va: -0.2)
    @cl.read
    @pos2d.speed.should eql(vx: 1.0, vy: 0.5, va: -0.2)
    @pos2d.stoped?.should be_false

    # Stop robot
    @pos2d.stop
    @cl.read
    @pos2d.speed.should eql(vx: 0.0, vy: 0.0, va: 0.0)
    @pos2d.stoped?.should be_true
  end

  it 'should turn on motor' do
    pending "Don't work with Player/Stage"
    @pos2d.enable.should be_false
    @pos2d.enable = true
  end

  after do 
    @cl.close unless @cl.closed?
  end
end
