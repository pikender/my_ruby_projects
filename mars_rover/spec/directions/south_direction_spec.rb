require 'spec_helper'

describe SouthDirection do
  let(:south_direction) {SouthDirection.instance}

  let(:rover) {Rover.new(0,1,"S")}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end  

  it 'should turn_left and update direction as East and coordinates remain same' do
    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(EastDirection)
  end

  it 'should turn_right and update direction as West and coordinates remain same' do
    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(WestDirection)
  end

  it 'should move and reduce the y coordinate by 1 step and direction remain same' do
    rover.move
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(SouthDirection)
  end

  it 'should return S as direction_name' do
    south_direction.direction_name.should eq("S")
  end

  it 'should return SOUTH when only class to_s' do
    south_direction.to_s.should eq("SOUTH")
  end
end
