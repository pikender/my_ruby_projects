class PlateauGrid
  @@instance = PlateauGrid.new
  private_class_method :new
  
  attr_reader :min_x, :min_y, :max_x, :max_y

  def self.instance
     return @@instance
  end

  def set_upper_bounds(max_x, max_y)
    @min_x = 0
    @min_y = 0
    @max_x = max_x
    @max_y = max_y
  end

## Will not allow Machine to move if going out of grid as of now
## In some situations, like pacman, it might reach the other end 
## as if terrain is circular :P
  def is_move_possible?(to_x, to_y)
    return false if (to_x > @max_x || to_y > @max_y || to_x < @min_x || to_y < @min_y)
    return true
  end
end
