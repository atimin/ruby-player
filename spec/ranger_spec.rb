require "ruby-player"

describe Player::Ranger do
  before do 
    @cl = Player::Client.connect("localhost") 
    @ranger = @cl[:ranger,0]
    @cl.read
  end

  it 'should have ranges' do
    @ranger.ranges.should eq([3.0, 3.0]) 
  end

  it 'should have intensities' do
    @ranger.intensities.should eq([0.0, 0.0]) 
  end

  it 'should have bearings' do
    @ranger.bearings.size.should eql(2)
  end

  it 'should have element count' do
    @ranger.element_count.should eq(0)
  end

  it 'should have power control' do
    pending "Don't work with Player/Stage"
    #@ranger.power_enable = false
    #@ranger.power_enable = true
  end

  it 'should have intensity control' do
    pending "Don't work with Player/Stage"
    #@ranger.intensity_enable = false
    #@ranger.intensity_enable = true
  end

  it 'should porovide method to configurate' do
    pending "Don't work with Player/Stage"
    config = {
      min_angle: 0.3,
      max_angle: 1.0,
      angular_res: 0.1,
      min_range: 0.3,
      max_range: 1,
      range_res: 0.1,
      frequecy: 2
    }


    #@ranger.set_config(config)
  end

  it 'should have configuration' do
    @ranger.config.should eq(
      :min_range=>0.1, 
      :max_range=>3.0, 
      :angular_res=>0.5235987755982988, 
      :range_res=>0.02, 
      :frequecy=>10.0
    )
  end

  after do 
    @cl.close unless @cl.closed?
  end
end
