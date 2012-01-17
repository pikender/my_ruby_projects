require 'spec_helper'

describe EastDirection do
  let(:east_direction) {EastDirection.instance}

  let(:rover) {Rover.new(0,0,"E")}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end  

  it 'should turn_left and update direction as North and coordinates remain same' do
    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(NorthDirection)
  end

  it 'should turn_right and update direction as South and coordinates remain same' do
    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(SouthDirection)
  end

  it 'should move and increase the x coordinate by 1 step and direction remain same' do
    rover.move
    rover.location.l_coordinates.x.should eq(1)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(EastDirection)
  end

  it 'should return E as direction_name' do
    east_direction.direction_name.should eq("E")
  end

  it 'should return East when only class to_s' do
    east_direction.to_s.should eq("EAST")
  end
end
