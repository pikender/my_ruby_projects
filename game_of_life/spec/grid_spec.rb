require 'spec_helper'

describe Grid do
  let(:grid_inst) {Grid.new}

  let(:sample_cell) {Cell.new(1,1)}

  it "should initialize without error" do
    grid_inst.should respond_to(:cells)
  end

  it "should initialize cells as an empty Array" do
    grid_inst.cells.should be_an_instance_of(Array)
    grid_inst.cells.should be_empty
  end

  it "should allow addition (<<) and removal of cells in the grid" do    
    grid_inst << sample_cell
    grid_inst.cells.should_not be_empty
    grid_inst.cells.first.x.should eq(1)
    grid_inst.cells.first.y.should eq(1)
    
    grid_inst.remove_cell(sample_cell)
    grid_inst.cells.should be_empty
  end

  it "should warn on duplicate addition of cells in the grid" do    
    grid_inst << sample_cell
    (grid_inst << sample_cell).should match(/Already present in grid/)
  end

  context "should display Grid in Tabular Format with Live Cells as X and dead cells as - " do
# Even diaplay method also passes as last object in it is same array returned as by two_d_display but priniting output on console in tests so not used it
    it "should display for Block Pattern" do
      grid_inst << Cell.new(1,1)
      grid_inst << Cell.new(1,2)
      grid_inst << Cell.new(2,1)
      grid_inst << Cell.new(2,2)
      grid_inst.two_d_display.should eq([["X", "X"], 
                                   ["X", "X"]])
    end

    it "should display for Boat Pattern" do
      grid_inst << Cell.new(0,1)
      grid_inst << Cell.new(1,0)
      grid_inst << Cell.new(2,1)
      grid_inst << Cell.new(0,2)
      grid_inst << Cell.new(1,2)
      grid_inst.two_d_display.should eq([["-", "X", "X"], 
                                   ["X", "-", "X"], 
                                   ["-", "X", "-"]])
    end

    it "should display for Blinker Pattern" do
      grid_inst << Cell.new(1,1)
      grid_inst << Cell.new(1,0)
      grid_inst << Cell.new(1,2)
      grid_inst.two_d_display.should eq([["X", "X", "X"]])
    end

    it "should display for Toad Pattern" do
      grid_inst << Cell.new(1,1)
      grid_inst << Cell.new(1,2)
      grid_inst << Cell.new(1,3)
      grid_inst << Cell.new(2,2)
      grid_inst << Cell.new(2,3)
      grid_inst << Cell.new(2,4)
      grid_inst.two_d_display.should eq([["X", "X", "X", "-"], ["-", "X", "X", "X"]])
    end
  end

  it "should not allow following method calls i.e. max_xy, min_xy" do
    expect {grid_inst.debug_xy(sample_cell.x, sample_cell.y)}.to raise_exception(NoMethodError, /private method `debug_xy'/)
    expect {grid_inst.max_xy}.to raise_exception(NoMethodError,  /private method `max_xy'/)
    expect {grid_inst.min_xy}.to raise_exception(NoMethodError,  /private method `min_xy'/)
  end
end
