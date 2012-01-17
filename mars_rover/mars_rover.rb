require 'yaml'

Dir["./lib/**/*.rb"].each {|f| require f}

##Load YAML INpUT
mars_rover_inputs = YAML.load_file("mars_rover.yml")

##Set Plateau Grid
plateau_grid_input = mars_rover_inputs["plateau_grid"]

plateau_grid = PlateauGrid.instance
plateau_grid.set_upper_bounds(plateau_grid_input["max_x"], plateau_grid_input["max_y"])

##Place Rovers
first_rover_input = mars_rover_inputs["first_rover"]
r = Rover.new(first_rover_input["x"], first_rover_input["y"], first_rover_input["direction"])

## Starting Rover Location
p r.current_location

##Move Rovers
##Ask Actuator to move rovers
rover_commands = first_rover_input["move_commands"]

a = Actuator.new
a.operate(r, rover_commands)

##Check Final Position of Rovers
p r.current_location

## Same LOcation Check
first_rover_final_xy_dir = first_rover_input["final"]
p (r.location.l_coordinates.x)
p (r.location.l_coordinates.y)
p (r.location.direction.direction_name)

p (r.location.l_coordinates.x == first_rover_final_xy_dir["x"] &&
  r.location.l_coordinates.y == first_rover_final_xy_dir["y"] &&
  r.location.direction.direction_name == first_rover_final_xy_dir["direction"])

mars_rover_inputs.each_pair do |k,v|
  next if (k == "plateau_grid")
  ##Place Rovers
  r = Rover.new(v["x"], v["y"], v["direction"])

  ## Starting Rover Location
  p r.current_location

  ##Move Rovers
  ##Ask Actuator to move rovers
  rover_commands = v["move_commands"]

  a = Actuator.new
  a.operate(r, rover_commands)

  ##Check Final Position of Rovers
  p r.current_location

  ## Same LOcation Check
  rover_final_xy_dir = v["final"]
#  p (r.location.l_coordinates.x)
#  p (r.location.l_coordinates.y)
#  p (r.location.direction.direction_name)

  p (r.location.l_coordinates.x == rover_final_xy_dir["x"] &&
    r.location.l_coordinates.y == rover_final_xy_dir["y"] &&
    r.location.direction.direction_name == rover_final_xy_dir["direction"])

end
