class LifeCommand < Command
  attr_reader :cell

  def initialize(cell)
    @cell = cell
    super("Generic Life Command")
  end

  def execute
  end
end
