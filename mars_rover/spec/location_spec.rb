require 'spec_helper'

describe Location do
  let(:location_north) {Location.new(0,0,"N")}
  let(:location_east) {Location.new(1,0,"E")}
  let(:location_west) {Location.new(0,1,"W")}
  let(:location_south) {Location.new(0,0,"S")}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end
  
  it 'should respond to l_coordinates and direction' do
    location_north.should respond_to(:l_coordinates)
    location_north.should respond_to(:direction)
  end
  
  it 'should correctly initialize rover coordinates and direction' do
    location_north.l_coordinates.x.should eq(0)
    location_north.l_coordinates.y.should eq(0)

    location_east.l_coordinates.x.should eq(1)
    location_east.l_coordinates.y.should eq(0)

    location_west.l_coordinates.x.should eq(0)
    location_west.l_coordinates.y.should eq(1)

    location_north.direction.should be_an_instance_of(NorthDirection)
    location_east.direction.should be_an_instance_of(EastDirection)
    location_west.direction.should be_an_instance_of(WestDirection)
    location_south.direction.should be_an_instance_of(SouthDirection)
  end

  it 'should increase or decrease X or Y if allowed' do
    location_east.increase_x
    location_east.l_coordinates.x.should eq(2)
    location_east.l_coordinates.y.should eq(0)

    location_east.reduce_x
    location_east.l_coordinates.x.should eq(1)
    location_east.l_coordinates.y.should eq(0)

    location_east.increase_y
    location_east.l_coordinates.x.should eq(1)
    location_east.l_coordinates.y.should eq(1)

    location_east.reduce_y
    location_east.l_coordinates.x.should eq(1)
    location_east.l_coordinates.y.should eq(0)
  end

  it 'should not change X or Y if not allowed' do
    location_south.reduce_y
    location_south.l_coordinates.x.should eq(0)
    location_south.l_coordinates.y.should eq(0)

    location_south.reduce_x
    location_south.l_coordinates.x.should eq(0)
    location_south.l_coordinates.y.should eq(0)
  end
end
