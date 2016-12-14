class DieCommand < Command
  attr_reader :cell

  def initialize(cell)
    @cell = cell
    super("Command to Die")
  end

  def execute
    @cell.die
  end
end
