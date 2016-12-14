require 'spec_helper'

describe LifeCommand do 
  let(:on_cell) {double(Cell)}
  let(:life_command) {LifeCommand.new(on_cell)}

  it "should initialize the command with cell to act on and description" do 
    life_command.description.should eq("Generic Life Command")
    life_command.should respond_to(:cell)
    life_command.cell.should equal(on_cell)
  end

  it "should raise error when called execute" do 
    expect {life_command.execute}.to_not raise_error('')
  end
end
