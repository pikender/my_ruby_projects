class DeadState < CellState
  @@instance = DeadState.new
  private_class_method :new

  def live
    super()
  end

  def die
    DeadState.instance
  end

  def toggle
    live
  end

  def isAlive?
    false
  end

  def print_char
    '-'
  end

  def self.instance
    return @@instance
  end

  def accept(life_visitor, cmds, game_of_life, cell)
    life_visitor.visitDeadCell(cmds, game_of_life, cell)
  end

  def to_s
    "Cell is Dead"
  end
end
