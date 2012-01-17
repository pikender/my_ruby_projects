require 'spec_helper'

describe Rule3Unchanged2Or3LiveNeighbours do
  let(:rule3_inst) {Rule3Unchanged2Or3LiveNeighbours.new}

  let(:cell_inst) {Cell.new(1,1)}

  let(:grid_pattern) {Grid.new}

  let(:next_gen_grid_pattern) {Grid.new}
  
  it "should not allow live_unchanged method call" do
    expect {rule3_inst.live_unchanged(cell_inst, grid_pattern)}.to raise_exception(NoMethodError, /private method `live_unchanged'/)
  end 
  
  it "should leave cells unchanged with TWO OR THREE Neighbours" do 
    toad_cell_inst_1 = Cell.new(1,1)
    toad_cell_inst_2 = Cell.new(1,2)
    toad_cell_inst_3 = Cell.new(1,3)
    toad_cell_inst_4 = Cell.new(2,2)
    toad_cell_inst_5 = Cell.new(2,3)
    toad_cell_inst_6 = Cell.new(2,4)

    grid_pattern << toad_cell_inst_1
    grid_pattern << toad_cell_inst_2
    grid_pattern << toad_cell_inst_3
    grid_pattern << toad_cell_inst_4
    grid_pattern << toad_cell_inst_5
    grid_pattern << toad_cell_inst_6

    alive_cells_in_toad_grid = grid_pattern.cells

    toad_cell_inst_1.alive_neighbours(alive_cells_in_toad_grid).should eq(2)
    toad_cell_inst_6.alive_neighbours(alive_cells_in_toad_grid).should eq(2)

    rule3_inst.apply_rule(alive_cells_in_toad_grid, next_gen_grid_pattern)

    next_gen_grid_pattern.cells.should include(toad_cell_inst_1, toad_cell_inst_6)
  end
end
