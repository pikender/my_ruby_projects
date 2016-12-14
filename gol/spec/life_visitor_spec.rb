require 'spec_helper'

describe LifeVisitor do
  let(:life_visitor) {LifeVisitor.new}  
  let(:cmds) {CompositeCommand.new}  
  let(:game_of_life) {GameofLife.new}

  let(:cell_11) {Cell.new(1,1)}
  let(:cell_10) {Cell.new(1,0)}
  let(:cell_12) {Cell.new(1,2)}

  before(:each) do 
    cell_11.live
    cell_10.live
    cell_12.live

    game_of_life << cell_11
    game_of_life << cell_10
    game_of_life << cell_12

    game_of_life.grid_complete
  end

  it "should remove redundancy of accept by introducing visit" do
    pending '#    self.send( \"visit_#{cell.class.name}\".to_sym, object )'
  end

  it "should visit live cell and add appropriate command" do
    life_visitor.visitAliveCell(cmds, game_of_life, cell_10)
    cmds.commands.should be_empty
  end

  it "should visit dead cell and add appropriate command" do
    pending 'visitDeadCell(cmds, game_of_life, cell)'
  end

  it "should count alive neighbours" do
    pending 'count_alive_neighbours(game_of_life, cell)'
  end
end
