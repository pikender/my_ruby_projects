require 'spec_helper'

describe Cell do
  let(:invalid_cell_inst) {Cell.new}

  let(:invalid_cell_inst_1) {Cell.new(1)}

  let(:cell_inst) {Cell.new(1,1)}

  let(:cell_inst_1) {Cell.new(1,1)}

  let(:cell_inst_2) {Cell.new(2,2)}

  let(:grid_inst) {Grid.new}

  it "should raise Argument Error when x and y not given" do
    expect {invalid_cell_inst}.to raise_exception(ArgumentError)
    expect {invalid_cell_inst_1}.to raise_exception(ArgumentError)
  end

  it "should raise Any Error when x and y are given" do
    expect {cell_inst}.to_not raise_exception(ArgumentError)
  end

  it "should return true when == called on two objects with same x,y" do
    (cell_inst == cell_inst_1).should be_true
  end

  it "should return false when == called on two objects with different x,y" do
    (cell_inst == cell_inst_2).should be_false
  end

  it "should return all neighbours except itself" do
    neighbour_0 = Cell.new(1,1)
    neighbour_1 = Cell.new(0,0)
    neighbour_2 = Cell.new(0,1)
    neighbour_3 = Cell.new(0,2)
    neighbour_4 = Cell.new(1,0)
    neighbour_5 = Cell.new(1,2)
    neighbour_6 = Cell.new(2,0)
    neighbour_7 = Cell.new(2,1)
    neighbour_8 = Cell.new(2,2)
    cell_inst.all_neighbours.should_not be_empty
    cell_inst.all_neighbours.should_not include(neighbour_0)
    cell_inst.all_neighbours.should include(neighbour_1, neighbour_2, neighbour_3, neighbour_4, neighbour_5, neighbour_6, neighbour_7, neighbour_8)
  end

  context "blinker_pattern" do
    let(:blinker_cell_inst_1) { Cell.new(1,0) }
    let(:blinker_cell_inst_3) { Cell.new(1,2) }

    let(:blinker_cell_inst_4) { Cell.new(0,1) }
    let(:blinker_cell_inst_5) { Cell.new(2,1) }

    let(:blinker_cell_inst_6) { Cell.new(2,0) }
    
    before(:each) do
      grid_inst << blinker_cell_inst_1
      grid_inst << cell_inst
      grid_inst << blinker_cell_inst_3
    end

    it "should return live neighbours count" do    
      alive_cells_in_blinker_grid = grid_inst.cells

      blinker_cell_inst_1.alive_neighbours(alive_cells_in_blinker_grid).should eq(1)
      cell_inst.alive_neighbours(alive_cells_in_blinker_grid).should eq(2)
      blinker_cell_inst_3.alive_neighbours(alive_cells_in_blinker_grid).should eq(1)

      blinker_cell_inst_4.alive_neighbours(alive_cells_in_blinker_grid).should eq(3)
      blinker_cell_inst_5.alive_neighbours(alive_cells_in_blinker_grid).should eq(3)

      blinker_cell_inst_6.alive_neighbours(alive_cells_in_blinker_grid).should eq(2)
    end

    it "should confirm whether given cell is dead neighbour or live" do    
      alive_cells_in_blinker_grid = grid_inst.cells

      blinker_cell_inst_1.should_not be_a_dead_neighbour(blinker_cell_inst_4.all_neighbours,alive_cells_in_blinker_grid)

      blinker_cell_inst_4.should be_a_dead_neighbour(blinker_cell_inst_1.all_neighbours,alive_cells_in_blinker_grid)

      blinker_cell_inst_8 = Cell.new(4,4)
      
      pending "blinker_cell_inst_8.should be_a_dead_neighbour(blinker_cell_inst_8.all_neighbours,alive_cells_in_blinker_grid)"
    end
  end
end

