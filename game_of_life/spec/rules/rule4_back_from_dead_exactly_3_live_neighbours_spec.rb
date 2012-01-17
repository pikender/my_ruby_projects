require 'spec_helper'

describe Rule4BackFromDeadExactly3LiveNeighbours do
  let(:rule4_inst) {Rule4BackFromDeadExactly3LiveNeighbours.new}

  let(:cell_inst) {Cell.new(1,1)}

  let(:grid_pattern) {Grid.new}

  let(:next_gen_grid_pattern) {Grid.new}
  
  it "should not allow die_crowded method call" do
    expect {rule4_inst.back_from_dead(cell_inst, grid_pattern)}.to raise_exception(NoMethodError, /private method `back_from_dead'/)
  end 
  
  it "should delete crowded cell i.e cell with FOUR OR MORE Neighbours" do 
    toad_cell_inst_1 = Cell.new(1,1)
    toad_cell_inst_2 = Cell.new(1,2)
    toad_cell_inst_3 = Cell.new(1,3)
    toad_cell_inst_4 = Cell.new(2,2)
    toad_cell_inst_5 = Cell.new(2,3)
    toad_cell_inst_6 = Cell.new(2,4)

    toad_cell_inst_7 = Cell.new(0,2)
    toad_cell_inst_8 = Cell.new(2,1)

    grid_pattern << toad_cell_inst_1
    grid_pattern << toad_cell_inst_2
    grid_pattern << toad_cell_inst_3
    grid_pattern << toad_cell_inst_4
    grid_pattern << toad_cell_inst_5
    grid_pattern << toad_cell_inst_6

    all_neighbours_of_1x2 = toad_cell_inst_2.all_neighbours

    alive_cells_in_toad_grid = grid_pattern.cells

    toad_cell_inst_7.should be_a_dead_neighbour(all_neighbours_of_1x2,alive_cells_in_toad_grid)
    toad_cell_inst_8.should be_a_dead_neighbour(all_neighbours_of_1x2,alive_cells_in_toad_grid)

    toad_cell_inst_7.alive_neighbours(alive_cells_in_toad_grid).should eq(3)
    toad_cell_inst_8.alive_neighbours(alive_cells_in_toad_grid).should eq(3)

    rule4_inst.apply_rule(alive_cells_in_toad_grid, next_gen_grid_pattern)

    next_gen_grid_pattern.cells.should include(toad_cell_inst_7, toad_cell_inst_8)
  end
end
