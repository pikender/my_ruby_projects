require 'spec_helper'

describe CompositeCommand do 
  let(:composite_command) {CompositeCommand.new}
  let(:live_command) {double(LiveCommand)}
  let(:die_command) {double(DieCommand)}

  before(:each) do
    live_command.stub(:description) {"Live Command Desc"}
    live_command.stub(:execute) {"Live Command Executed"}
    live_command.stub_chain(:cell, :to_debug) {"Cell : row=0, col=0, Alive"}

    die_command.stub(:description) {"Die Command Desc"}
    die_command.stub(:execute) {"Die Command Executed"}
    die_command.stub_chain(:cell, :to_debug) {"Cell : row=0, col=0, Dead"}
  end

  it "should initialize commands array to hold command instances" do
    composite_command.should respond_to(:commands)
    composite_command.commands.should be_kind_of(Array)
    composite_command.commands.should be_empty
  end

  context "After Add Commands" do 
    before(:each) do
      composite_command.add_command(live_command)
      composite_command.add_command(die_command)
    end

    it "should be able to add commands" do
      composite_command.commands.should_not be_empty
    end

    it "should be able to provide description of added commands" do
      composite_command.should respond_to(:description)
      composite_command.commands.should have_exactly(2).items
      composite_command.description.should eq("Cell : row=0, col=0, Alive Live Command Desc\nCell : row=0, col=0, Dead Die Command Desc\n")
    end

    it "should be able to execute the added commands" do
      composite_command.should respond_to(:execute)
      composite_command.commands.should have_exactly(2).items
      composite_command.execute.should include(live_command, die_command)
    end

    it "should be able to delete the added commands" do
      composite_command.commands.should have_exactly(2).items
      composite_command.delete_command(die_command)
      composite_command.commands.should have_exactly(1).items
      composite_command.commands.should include(live_command)
    end
  end
end
