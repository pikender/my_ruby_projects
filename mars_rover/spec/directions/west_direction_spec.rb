require 'spec_helper'

describe WestDirection do
  let(:west_direction) {WestDirection.instance}

  let(:rover) {Rover.new(1,0,"W")}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end  

  it 'should turn_left and update direction as South and coordinates remain same' do
    rover.turn_left
    rover.location.l_coordinates.x.should eq(1)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(SouthDirection)
  end

  it 'should turn_right and update direction as North and coordinates remain same' do
    rover.turn_right
    rover.location.l_coordinates.x.should eq(1)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(NorthDirection)
  end

  it 'should move and reduce the y coordinate by 1 step and direction remain same' do
    rover.move
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(WestDirection)
  end

  it 'should return W as direction_name' do
    west_direction.direction_name.should eq("W")
  end

  it 'should return WEST when only class to_s' do
    west_direction.to_s.should eq("WEST")
  end
end
