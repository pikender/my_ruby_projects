require 'spec_helper'

describe GameofLife do 

  it_should_behave_like "my observed" do 
    let(:observer_instances) {[GameofLifeUi.new, GameofLifeUi.new, GameofLifeUi.new]}
  end

  let(:sample_cell) {double(Cell)}
  let(:cell_11) {Cell.new(1,1)}
  let(:cell_12) {Cell.new(1,2)}
  let(:cell_21) {Cell.new(2,1)}
  let(:cell_22) {Cell.new(2,2)}
  let(:cell_01) {Cell.new(0,1)}
  let(:cell_02) {Cell.new(0,2)}
  let(:cell_10) {Cell.new(1,0)}
  let(:cell_12) {Cell.new(1,2)}
  let(:cell_21) {Cell.new(2,1)}
  let(:cell_13) {Cell.new(1,3)}
  let(:cell_23) {Cell.new(2,3)}
  let(:cell_24) {Cell.new(2,4)}
  let(:grid) {GameofLife.new}

  before(:each) do
    sample_cell.stub(:row) {0} 
    sample_cell.stub(:col) {0} 
  end

  it "should initialize grid with empty_cells" do 
    grid.should respond_to(:cells)
    grid.cells.should be_kind_of(Array)
    grid.cells.should be_empty
  end

  it "should allow addition (<<) and removal of cells in the grid" do    
    grid << sample_cell
    grid.cells.should_not be_empty
    grid.cells.should include(sample_cell)

    grid.cells.first.row.should eq(0)
    grid.cells.first.col.should eq(0)
    
    grid.remove_cell(sample_cell)
    grid.cells.should be_empty
  end

  it "should warn on duplicate addition of cells in the grid" do    
    grid << sample_cell
    (grid << sample_cell).should match(/Already present in grid/)
  end

  it "should advance" do
    pending "What to expect and compare"
  end

  context "should display Grid in Tabular Format with Live Cells as X and dead cells as - " do
    it "should display for Block Pattern" do
      cell_11.live
      cell_12.live
      cell_21.live
      cell_22.live

      grid << cell_11
      grid << cell_12
      grid << cell_21
      grid << cell_22

      grid.grid_complete

      grid.two_d_display.should eq([["-", "-", "-", "-"], 
                                    ["-", "X", "X", "-"], 
                                    ["-", "X", "X", "-"], 
                                    ["-", "-", "-", "-"]])  
    end

    it "should display for Boat Pattern" do
      cell_01.live
      cell_10.live
      cell_21.live
      cell_02.live
      cell_12.live

      grid << cell_01
      grid << cell_10
      grid << cell_21
      grid << cell_02
      grid << cell_12

      grid.grid_complete

      grid.two_d_display.should eq([["-", "X", "X", "-", "-"], 
                                    ["X", "-", "X", "-", "-"], 
                                    ["-", "X", "-", "-", "-"], 
                                    ["-", "-", "-", "0", "0"], 
                                    ["-", "-", "-", "-", "0"]])
    end

    it "should display for Blinker Pattern" do
      cell_11.live
      cell_10.live
      cell_12.live

      grid << cell_11
      grid << cell_10
      grid << cell_12

      grid.grid_complete

      grid.two_d_display.should eq([["-", "-", "-", "-", "-"], 
                                    ["X", "X", "X", "-", "-"], 
                                    ["-", "-", "-", "-", "-"]])
    end

    it "should display for Toad Pattern" do
      cell_11.live
      cell_12.live
      cell_13.live
      cell_22.live
      cell_23.live
      cell_24.live

      grid << cell_11
      grid << cell_12
      grid << cell_13
      grid << cell_22
      grid << cell_23
      grid << cell_24

      grid.grid_complete

      grid.two_d_display.should eq([["-", "-", "-", "-", "-", "0"], 
                                    ["-", "X", "X", "X", "-", "-"], 
                                    ["-", "-", "X", "X", "X", "-"], 
                                    ["0", "-", "-", "-", "-", "-"]])
    end
  end

  it "should complete the grid by initializing neighbouring dead cells - block pattern" do    
    cell_11.live
    cell_12.live
    cell_21.live
    cell_22.live

    grid << cell_11
    grid << cell_12
    grid << cell_21
    grid << cell_22

    grid.grid_complete

    grid.cells.collect {|c| [c.row, c.col]}.should include([0,0], [0,1], [0,2], [0,3], [1,0], [2,0], [3,0], [3,1], [3,2], [3,3], [1,3], [2,3])
  end

  it "should help debug grid by showing Cell Info" do
    pending "help debug grid by showing Cell Info"
  end


  it "should not allow following method calls i.e. max_xy, min_xy" do
    expect {grid.max_xy}.to raise_exception(NoMethodError,  /private method `max_xy'/)
    expect {grid.min_xy}.to raise_exception(NoMethodError,  /private method `min_xy'/)
  end
end
