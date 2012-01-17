require 'spec_helper'

describe Rule1LonelyOneOrNoLiveNeighbour do
  let(:rule1_inst) {Rule1LonelyOneOrNoLiveNeighbour.new}

  let(:cell_inst) {Cell.new(1,1)}

  let(:grid_pattern) {Grid.new}

  let(:next_gen_grid_pattern) {Grid.new}
  
  it "should not allow die_lonely method call" do
    expect {rule1_inst.die_lonely(cell_inst, grid_pattern)}.to raise_exception(NoMethodError, /private method `die_lonely'/)
  end 
  
  it "should delete lonely cell i.e cell with ONE or No Neighbour" do    
    blinker_cell_inst_1 = Cell.new(1,0)
    blinker_cell_inst_2 = Cell.new(1,1)
    blinker_cell_inst_3 = Cell.new(1,2)

    grid_pattern << blinker_cell_inst_1
    grid_pattern << blinker_cell_inst_2
    grid_pattern << blinker_cell_inst_3

    next_gen_grid_pattern << blinker_cell_inst_1
    next_gen_grid_pattern << blinker_cell_inst_2
    next_gen_grid_pattern << blinker_cell_inst_3

    alive_cells_in_blinker_grid = grid_pattern.cells

    blinker_cell_inst_1.alive_neighbours(alive_cells_in_blinker_grid).should eq(1)
    blinker_cell_inst_2.alive_neighbours(alive_cells_in_blinker_grid).should eq(2)
    blinker_cell_inst_3.alive_neighbours(alive_cells_in_blinker_grid).should eq(1)

    rule1_inst.apply_rule(alive_cells_in_blinker_grid, next_gen_grid_pattern)

    next_gen_grid_pattern.cells.should_not include(blinker_cell_inst_1, blinker_cell_inst_3)
    next_gen_grid_pattern.cells.should include(blinker_cell_inst_2)
  end
end
