require 'spec_helper'

describe Cell do
  let(:cell_instance) {Cell.new(0,0)}
  let(:cell_instance_1) {Cell.new(0,0)}
  let(:neighbour_cell_instance) {Cell.new(1,1)}

  it "should properly initialize row, columns, cell state and neighbours row - columns" do
    cell_instance.should respond_to(:row)
    cell_instance.should respond_to(:col)
    cell_instance.should respond_to(:cell_state)
    cell_instance.should respond_to(:neighbours_xy)

    cell_instance.row.should eq(0)
    cell_instance.col.should eq(0)
    cell_instance.cell_state.should be_an_instance_of(CellState)
    cell_instance.neighbours_xy.should include([1,0], [1,1], [1,0], [-1,1], [-1,0], [-1,-1], [0,-1], [1, -1])
  end

  it "should properly initialize neighbours row and columns" do
    pending "checked indirectly in initialization .. to test independently .. we need to pass x and y .. does it make sense"
  end

  it "should return true when == called on two objects with same row and col" do
    cell_instance.live
    cell_instance_1.die
    cell_instance.should be_isAlive
    cell_instance_1.should_not be_isAlive
    (cell_instance == cell_instance_1).should be_true
  end

  it "should be able to confirm its neighbouring cells" do
    cell_instance.should be_is_neighbour(neighbour_cell_instance)
  end

  it "should be able to confirm whether neighbouring cell is dead or alive" do
    cell_instance.should_not be_is_alive_neighbour(neighbour_cell_instance)
    neighbour_cell_instance.live
    cell_instance.should be_is_alive_neighbour(neighbour_cell_instance)
  end

  it "should return class instance of AliveState when called live" do
    cell_instance.live
    cell_instance.cell_state.should be_an_instance_of(AliveState)
  end

  it "should return class instance of DeadState when called die" do
    cell_instance.die
    cell_instance.cell_state.should be_an_instance_of(DeadState)
  end

  it "should return class instance of DeadState when called toggle" do
    cell_instance.live
    cell_instance.toggle
    cell_instance.cell_state.should be_an_instance_of(DeadState)
    cell_instance.toggle
    cell_instance.cell_state.should be_an_instance_of(AliveState)
  end

  it "should return Cell is Alive when called isAlive" do
    cell_instance.live
    cell_instance.should be_isAlive
    cell_instance.die
    cell_instance.should_not be_isAlive
  end

  it "should print 'X' when asked to print itself" do
    cell_instance.live
    cell_instance.print_char.should eq('X')
    cell_instance.die
    cell_instance.print_char.should eq('-')
  end

  it "should return properly formatted debug statement" do
    cell_instance.live    
    cell_instance.to_debug.should eq("Cell: row=0, col=0, state=true")
    cell_instance.die
    cell_instance.to_debug.should eq("Cell: row=0, col=0, state=false")
  end

  it "should accept" do
    pending "What to expect and compare"
  end

end
