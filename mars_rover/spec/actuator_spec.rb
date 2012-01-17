require 'spec_helper'

describe Actuator do
  let(:actuator) {Actuator.new}

  let(:rover) {Rover.new(0,0,"N")}

  let(:commands) {"RMLML"}

  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end

  it "should operate rovers based on commands" do
    actuator.operate(rover, commands)
    rover.location.l_coordinates.x.should eq(1)
    rover.location.l_coordinates.y.should eq(1)
    rover.location.direction.should be_an_instance_of(WestDirection)
  end
end
