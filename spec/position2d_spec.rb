require "ruby-player"

describe Player::Position2d do
  before do
    @cl = Player::Client.connect("localhost") 
    @pos2d = @cl[:position2d, 0]
    @cl.read
  end

  it 'should move' do
    pos = @pos2d.pose
    speed = [-0.4, 0.2, -0.1]
    @pos2d.set_vel(*speed)

    sleep(1.1)
    @cl.read
    @pos2d.vel.should eq(speed)
    @pos2d.vx.should eql(speed[0])
    @pos2d.vy.should eql(speed[1])
    @pos2d.va.should eql(speed[2])

    #change position
    @pos2d.px.should be_within(0.1).of(pos[0] + speed[0]*Math.cos(pos[2]) - speed[1]*Math.sin(pos[2]))
    @pos2d.py.should be_within(0.1).of(pos[1] + speed[0]*Math.sin(pos[2]) + speed[1]*Math.cos(pos[2]))
    Math.sin(@pos2d.pa).should be_within(0.1).of(Math.sin(pos[2] + speed[2]))
  end


  it 'should move like car' do
    pos = @pos2d.pose
    speed = [0.4, 0.0, 0.3]
    @pos2d.set_car(speed[0], speed[2])

    sleep(1.1)
    @cl.read
    @pos2d.vel.should eq(speed)
    @pos2d.vx.should eql(speed[0])
    @pos2d.vy.should eql(0.0)
    @pos2d.va.should eql(speed[2])

    #change position
    @pos2d.px.should be_within(0.1).of(pos[0] + speed[0]*Math.cos(pos[2]))
    @pos2d.py.should be_within(0.1).of(pos[1] + speed[0]*Math.sin(pos[2]))
    Math.sin(@pos2d.pa).should be_within(0.1).of(Math.sin(pos[2] + speed[2]))

  end

  it 'should turn on motor' do
    #Don't need for Player/Stage
    @pos2d.enable.should be_false
    @pos2d.enable = true
  end

  after do 
    @cl.close unless @cl.closed?
  end
end
