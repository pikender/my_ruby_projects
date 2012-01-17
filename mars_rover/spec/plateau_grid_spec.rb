require 'spec_helper'

describe PlateauGrid do
  let(:plateau_grid) {PlateauGrid.instance}

  before(:each) do
    plateau_grid.set_upper_bounds(4,5)
  end

  it 'should set plateau rectangular bounds' do
    plateau_grid.min_x.should eq(0)
    plateau_grid.min_y.should eq(0)

    plateau_grid.max_x.should eq(4)
    plateau_grid.max_y.should eq(5)
  end

  it 'should allow movement with in grid' do
    plateau_grid.should be_is_move_possible(4,5)
    plateau_grid.should be_is_move_possible(3,4)
  end

  it 'should not allow movement outside the grid' do
    plateau_grid.should_not be_is_move_possible(4,6)
    plateau_grid.should_not be_is_move_possible(5,5)

    plateau_grid.should_not be_is_move_possible(-1,0)
    plateau_grid.should_not be_is_move_possible(0,-1)
  end
end
