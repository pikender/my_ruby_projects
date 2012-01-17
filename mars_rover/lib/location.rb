class Location
  attr_accessor :l_coordinates, :direction

  def initialize(x, y, direction)
    @l_coordinates = Coordinates.new(x, y)
    @plateau_grid = PlateauGrid.instance
    @direction = DirectionManager.get_direction(direction)
  end

  def increase_x
    @l_coordinates.x += 1 if @plateau_grid.is_move_possible?(@l_coordinates.x + 1, @l_coordinates.y)
  end

  def increase_y
    @l_coordinates.y += 1 if @plateau_grid.is_move_possible?(@l_coordinates.x, @l_coordinates.y + 1)
  end

  def reduce_x
    @l_coordinates.x -= 1 if @plateau_grid.is_move_possible?(@l_coordinates.x - 1, @l_coordinates.y)
  end

  def reduce_y
    @l_coordinates.y -= 1 if @plateau_grid.is_move_possible?(@l_coordinates.x, @l_coordinates.y - 1)
  end
end
