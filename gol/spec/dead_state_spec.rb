require 'spec_helper'

describe DeadState do
  let(:dead_instance)  {DeadState.instance}

  it "should throw error when called new" do
    expect {DeadState.new}.to raise_exception {|error| error.should be_a(NoMethodError)}
  end

  it "should return class instance of DeadState when called instance" do
    dead_instance.should be_an_instance_of(DeadState)
  end

  it "should return class instance of AliveState when called live" do
    dead_instance.live.should be_an_instance_of(AliveState)
  end

  it "should return class instance of DeadState when called die" do
    dead_instance.die.should be_an_instance_of(DeadState)
  end

  it "should return class instance of AliveState when called toggle" do
    dead_instance.toggle.should be_an_instance_of(AliveState)
  end

  it "should return Cell is Dead when called isAlive" do
    dead_instance.should_not be_isAlive
  end

  it "should print '-' when asked to print itself" do
    dead_instance.print_char.should eq('-')
  end

  it "should print Cell is Dead when asked class name" do
    dead_instance.to_s.should eq("Cell is Dead")
  end

  it "should accept" do
    pending "What to expect and compare"
  end

end
