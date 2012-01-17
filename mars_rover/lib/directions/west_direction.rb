class WestDirection < Direction
  @@instance = WestDirection.new
  private_class_method :new
  
  def self.instance
    return @@instance
  end

  def move(r)
    r.location.reduce_x
  end

  def turn_left(r)
    r.location.direction = DirectionManager.get_direction("S")
  end

  def turn_right(r)
    r.location.direction = DirectionManager.get_direction("N")
  end

  def direction_name
    "W"
  end

  def to_s
    "WEST"
  end
end
