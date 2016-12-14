require 'spec_helper'

describe CellState do
  let(:cell_state) {CellState.new}  

  it "should return class instance of AliveState when called live" do
    cell_state.live.should be_an_instance_of(AliveState)
  end

  it "should return class instance of DeadState when called die" do
    cell_state.die.should be_an_instance_of(DeadState)
  end

  it "should return class instance of DeadState when called toggle" do
    expect {cell_state.toggle}.to raise_error("NotImplemented :: Call Actual State toggle")
  end

  it "should return Cell is Dead when called isAlive" do
    cell_state.should_not be_isAlive
  end

  it "should print 'X' when asked to print itself" do
    expect {cell_state.print_char}.to raise_error("NotImplemented :: Call Actual State print_char")
  end

  it "should accept" do
    pending "What to expect and compare"
  end
end
