require File.dirname(__FILE__) + "/spec_helper"

describe Player::Blob do
  before do
    @blob = Player::Blob.new(nil, nil)
  end

  it 'should have default values' do
    @blob.state.should eql(id: 0, color: 0, area: 0, x: 0, y: 0, left: 0, right: 0, top: 0, bottom: 0, range: 0.0) 
  end

  it 'should have #id attr' do
    @blob.should_receive(:state).and_return(id: 23)
    @blob.id.should eql(23)
  end

  it 'should have #color attr' do
    @blob.should_receive(:state).and_return(color: 0xfff)
    @blob.color.should eql(0xfff)
  end

  it 'should have #area attr' do
    @blob.should_receive(:state).and_return(area: 100)
    @blob.area.should eql(100)
  end

  it 'should have #x attr' do
    @blob.should_receive(:state).and_return(x: 10)
    @blob.x.should eql(10)
  end

  it 'should have #y attr' do
    @blob.should_receive(:state).and_return(y: 20)
    @blob.y.should eql(20)
  end

  it 'should have #left attr' do
    @blob.should_receive(:state).and_return(left: 15)
    @blob.left.should eql(15)
  end

  it 'should have #right attr' do
    @blob.should_receive(:state).and_return(right: 30)
    @blob.right.should eql(30)
  end

  it 'should have #top attr' do
    @blob.should_receive(:state).and_return(top: 45)
    @blob.top.should eql(45)
  end

  it 'should have #bottom attr' do
    @blob.should_receive(:state).and_return(bottom: 35)
    @blob.bottom.should eql(35)
  end

  it 'should have #ranger attr' do
    @blob.should_receive(:state).and_return(range: 0.2)
    @blob.range.should eql(0.2)
  end
end


