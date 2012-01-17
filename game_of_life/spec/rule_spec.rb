require 'spec_helper'

describe Rule do
  let(:rule_inst) {Rule.new}

  it "should not allow apply_rule to get called on Rule as its like interface" do
    grid_pattern = Grid.new
    next_gen_grid_pattern = Grid.new
    expect {rule_inst.apply_rule(grid_pattern, next_gen_grid_pattern)}.to raise_exception(/This function is not supposed to be called. Please use its subclasses and implement as per requirement./)
  end
end
