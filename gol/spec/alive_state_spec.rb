require 'spec_helper'

describe AliveState do
  let(:alive_instance)  {AliveState.instance}

  it "should throw error when called new" do
    expect {AliveState.new}.to raise_exception {|error| error.should be_a(NoMethodError)}
  end

  it "should return class instance of AliveState when called instance" do
    alive_instance.should be_an_instance_of(AliveState)
  end

  it "should return class instance of AliveState when called live" do
    alive_instance.live.should be_an_instance_of(AliveState)
  end

  it "should return class instance of DeadState when called die" do
    alive_instance.die.should be_an_instance_of(DeadState)
  end

  it "should return class instance of DeadState when called toggle" do
    alive_instance.toggle.should be_an_instance_of(DeadState)
  end

  it "should return Cell is Alive when called isAlive" do
    alive_instance.should be_isAlive
  end

  it "should print 'X' when asked to print itself" do
    alive_instance.print_char.should eq('X')
  end

  it "should print Cell is Alive when asked class name" do
    alive_instance.to_s.should eq("Cell is Alive")
  end

  it "should accept" do
    pending "What to expect and compare"
  end

end
