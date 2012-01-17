class DirectionManager
  @@instance = DirectionManager.new
  private_class_method :new
  
  def self.instance
    return @@instance
  end

  def self.get_direction(direction_string)
    case direction_string
      when "N"
        face_north
      when "E"
        face_east
      when "W"
        face_west
      when "S"
        face_south
      else
    end    
  end 

  def self.face_north
    NorthDirection.instance
  end 

  def self.face_east
    EastDirection.instance
  end 

  def self.face_west
    WestDirection.instance
  end 

  def self.face_south
    SouthDirection.instance
  end 
end  
