require 'spec_helper'

describe Direction do
  let(:direction) {Direction.new}
  let(:rover) {Rover.new(0,0,"N")}
  
  it 'should raise error when move called' do
    expect {direction.move(rover)}.to raise_error(/Call the actual direction implemetation/)
  end
  
  it 'should raise error when turn_left called' do
    expect {direction.turn_left(rover)}.to raise_error(/Call the actual direction implemetation/)    
  end
  
  it 'should raise error when turn_right called' do
    expect {direction.turn_right(rover)}.to raise_error(/Call the actual direction implemetation/)
  end
end
