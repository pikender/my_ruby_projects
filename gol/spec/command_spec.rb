require 'spec_helper'

describe Command do 
  let(:command) {Command.new("Command")}

  it "should raise error when no description given to command" do 
    expect {Command.new}.to raise_error(ArgumentError)
  end

  it "should initialize with description" do 
    command.should respond_to(:description)
    command.description.should eq("Command")
  end

  it "should raise error when called execute" do 
    expect {command.execute}.to raise_error(RuntimeError, /NotImplemented :: Call Actual Command's execute/)
  end
end
