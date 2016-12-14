class CellState
  def live
    AliveState.instance
  end

  def die
    DeadState.instance
  end

  def toggle
    raise "NotImplemented :: Call Actual State toggle"
  end

  def isAlive?
    false
  end

  def print_char
    raise "NotImplemented :: Call Actual State print_char"
  end

  def accept(life_visitor, cmds, game_of_life, cell)
  end
end
