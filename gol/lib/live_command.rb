class LiveCommand < Command
  attr_reader :cell

  def initialize(cell)
    @cell = cell
    super("Command to Live")
  end

  def execute
    @cell.live
  end
end
