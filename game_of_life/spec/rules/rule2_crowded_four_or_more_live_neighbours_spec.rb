require 'spec_helper'

describe Rule2CrowdedFourOrMoreLiveNeighbours do
  let(:rule2_inst) {Rule2CrowdedFourOrMoreLiveNeighbours.new}

  let(:cell_inst) {Cell.new(1,1)}

  let(:grid_pattern) {Grid.new}

  let(:next_gen_grid_pattern) {Grid.new}
  
  it "should not allow die_crowded method call" do
    expect {rule2_inst.die_crowded(cell_inst, grid_pattern)}.to raise_exception(NoMethodError, /private method `die_crowded'/)
  end 
  
  it "should delete crowded cell i.e cell with FOUR OR MORE Neighbours" do 
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

    next_gen_grid_pattern << toad_cell_inst_1
    next_gen_grid_pattern << toad_cell_inst_2
    next_gen_grid_pattern << toad_cell_inst_3
    next_gen_grid_pattern << toad_cell_inst_4
    next_gen_grid_pattern << toad_cell_inst_5
    next_gen_grid_pattern << toad_cell_inst_6

    alive_cells_in_toad_grid = grid_pattern.cells

    toad_cell_inst_2.alive_neighbours(alive_cells_in_toad_grid).should eq(4)
    toad_cell_inst_3.alive_neighbours(alive_cells_in_toad_grid).should eq(4)
    toad_cell_inst_4.alive_neighbours(alive_cells_in_toad_grid).should eq(4)
    toad_cell_inst_5.alive_neighbours(alive_cells_in_toad_grid).should eq(4)

    toad_cell_inst_1.alive_neighbours(alive_cells_in_toad_grid).should eq(2)
    toad_cell_inst_6.alive_neighbours(alive_cells_in_toad_grid).should eq(2)

    rule2_inst.apply_rule(alive_cells_in_toad_grid, next_gen_grid_pattern)

    next_gen_grid_pattern.cells.should_not include(toad_cell_inst_2, toad_cell_inst_3, toad_cell_inst_4, toad_cell_inst_5)
    next_gen_grid_pattern.cells.should include(toad_cell_inst_1, toad_cell_inst_6)
  end
end
