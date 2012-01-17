require 'spec_helper'

describe Rover do
  let(:rover) {Rover.new(0,0,"N")}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end

  
  it 'should respond_to location' do
    rover.should respond_to(:location)
  end

  it 'should return location as an instance of Location' do
    rover.location.should be_an_instance_of(Location)
  end

  it 'should turn_left and update direction and coordinates remain same' do
    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(WestDirection)

    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(SouthDirection)

    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(EastDirection)

    rover.turn_left
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(NorthDirection)
  end

  it 'should turn_right and update direction and coordinates remain same' do
    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(EastDirection)

    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(SouthDirection)

    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(WestDirection)

    rover.turn_right
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(NorthDirection)
  end

  it 'should move and update the coordinates and direction remain same' do
    rover.move
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(NorthDirection)

    rover.turn_right
    rover.move
    rover.location.l_coordinates.x.should eq(1)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(EastDirection)

    rover.turn_right
    rover.move
    rover.location.l_coordinates.x.should eq(1)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(SouthDirection)

    rover.turn_right
    rover.move
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(WestDirection)
  end

  it 'should follow the commands M and Move' do
    rover.send_control_command("M")
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(NorthDirection)
  end

  it 'should follow the commands L and Turn Left' do
    rover.send_control_command("L")
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(WestDirection)
  end

  it 'should follow the commands R and Turn Right' do
    rover.send_control_command("R")
    rover.location.l_coordinates.x.should eq(0)
    rover.location.l_coordinates.y.should eq(0)
    rover.location.direction.should be_an_instance_of(EastDirection)
  end

  it 'should not allow commands other than M, L or R' do
    expect {rover.send_control_command("J")}.to raise_error(/Invalid Control Command/)
  end

  it 'should present nicely formatted Location when asked for Current Location' do
    rover.current_location.should eq("0 0 N")
  end
end
