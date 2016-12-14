require 'spec_helper'

describe DieCommand do 
  let(:on_cell) {double(Cell)}
  let(:die_command) {DieCommand.new(on_cell)}

  before(:each) do
    on_cell.stub(:die) {"Cell State changed from live to dead"}
  end

  it "should initialize the command with cell to act on and description" do 
    die_command.description.should eq("Command to Die")
    die_command.should respond_to(:cell)
    die_command.cell.should equal(on_cell)
  end

  it "should execute and make the cell die" do 
    die_command.execute.should eq("Cell State changed from live to dead")
  end
end
