class NorthDirection < Direction
  @@instance = NorthDirection.new
  private_class_method :new
  
  def self.instance
    return @@instance
  end

  def move(r)
    r.location.increase_y
  end

  def turn_left(r)
    r.location.direction = DirectionManager.get_direction("W")
  end

  def turn_right(r)
    r.location.direction = DirectionManager.get_direction("E")
  end

  def direction_name
    "N"
  end

  def to_s
    "NORTH"
  end
end
