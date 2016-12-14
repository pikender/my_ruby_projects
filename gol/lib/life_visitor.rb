class LifeVisitor
  def visit(cmds, game_of_life, cell)
#    Eliminating accept
#    self.send( "visit_#{cell.class.name}".to_sym, object )
  end

  def visitAliveCell(cmds, game_of_life, cell)
    live_nbrs = count_alive_neighbours(game_of_life, cell)    
    cmds.add_command(DieCommand.new(cell)) if (live_nbrs < 2 || live_nbrs > 3)
  end

  def visitDeadCell(cmds, game_of_life, cell)    
    live_nbrs = count_alive_neighbours(game_of_life, cell)
    if live_nbrs == 3
      cmds.add_command(LiveCommand.new(cell))
    end  
  end

  def count_alive_neighbours(game_of_life, cell)
    live_neighbours = 0;
    game_of_life.cells.each do |c|
      if cell.is_alive_neighbour?(c)
        live_neighbours += 1
      end
    end
    live_neighbours
  end  
end
