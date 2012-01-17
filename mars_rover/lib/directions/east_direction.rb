class EastDirection < Direction
  @@instance = EastDirection.new
  private_class_method :new
  
  def self.instance
    return @@instance
  end

  def move(r)
    r.location.increase_x
  end

  def turn_left(r)
    r.location.direction = DirectionManager.get_direction("N")
  end

  def turn_right(r)
    r.location.direction = DirectionManager.get_direction("S")
  end

  def direction_name
    "E"
  end

  def to_s
    "EAST"
  end
end
