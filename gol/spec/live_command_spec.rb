require 'spec_helper'

describe LiveCommand do 
  let(:on_cell) {double(Cell)}
  let(:live_command) {LiveCommand.new(on_cell)}

  before(:each) do
    on_cell.stub(:live) {"Cell State changed from dead to alive"}
  end

  it "should initialize the command with cell to act on and description" do 
    live_command.description.should eq("Command to Live")
    live_command.should respond_to(:cell)
    live_command.cell.should equal(on_cell)
  end

  it "should execute and make the cell live" do 
    live_command.execute.should eq("Cell State changed from dead to alive")
  end
end
