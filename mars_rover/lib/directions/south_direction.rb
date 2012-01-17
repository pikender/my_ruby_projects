class SouthDirection < Direction
  @@instance = SouthDirection.new
  private_class_method :new
  
  def self.instance
    return @@instance
  end

  def move(r)
    r.location.reduce_y
  end

  def turn_left(r)
    r.location.direction = DirectionManager.get_direction("E")
  end

  def turn_right(r)
    r.location.direction = DirectionManager.get_direction("W")
  end

  def direction_name
    "S"
  end

  def to_s
    "SOUTH"
  end
end
