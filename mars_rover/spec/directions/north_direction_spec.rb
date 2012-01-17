require 'spec_helper'

describe NorthDirection do
  let(:north_direction) {NorthDirection.instance}

  let(:rover) {Rover.new(0,0,"N")}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end  

  it 'should turn_left and update direction as West and coordinates remain same' do
    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(WestDirection)
  end

  it 'should turn_right and update direction as East and coordinates remain same' do
    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(EastDirection)
  end

  it 'should move and increase the y coordinate by 1 step and direction remain same' do
    rover.move
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(NorthDirection)
  end

  it 'should return N as direction_name' do
    north_direction.direction_name.should eq("N")
  end

  it 'should return NORTH when only class to_s' do
    north_direction.to_s.should eq("NORTH")
  end
end
