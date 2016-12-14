class AliveState < CellState
  @@instance = AliveState.new
  private_class_method :new

  def live
    super()
  end

  def die
    DeadState.instance
  end

  def toggle
    die
  end

  def isAlive?
    true
  end

  def print_char
    'X'
  end

  def self.instance
    return @@instance
  end

  def accept(life_visitor, cmds, game_of_life, cell)
    life_visitor.visitAliveCell(cmds, game_of_life, cell)
  end

  def to_s
    "Cell is Alive"
  end
end
