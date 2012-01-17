class Rover
  attr_accessor :location

  def initialize(x, y, direction)
    @location = Location.new(x, y , direction)
  end

  def move
    @location.direction.move(self)
  end

  def turn_left
    @location.direction.turn_left(self)
  end

  def turn_right
    @location.direction.turn_right(self)
  end

  def send_control_command(control_command)
    case control_command
      when "M"
        move
      when "L"
        turn_left
      when "R"
        turn_right
      else
        raise "Invalid Control Command"
    end
  end

  def current_location
    "#{@location.l_coordinates.x} #{@location.l_coordinates.y} #{@location.direction.direction_name}"
  end
end
