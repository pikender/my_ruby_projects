require 'gol_helper.rb'

unless ARGV.size == 1
  puts "Only one pattern allowed as of now." 
  exit(1)
end

allowed_patterns = YAML.load_file("lib/grid.yml")

supplied_pattern = ARGV[0]
unless allowed_patterns.has_key?(supplied_pattern)
  puts "You entered --#{supplied_pattern}-- but Allowed Patterns are #{allowed_patterns.keys}"
  exit(1)
end

puts "Congratulations. You obeyed the program and program allows you to play in return. Hurray !!"

grid_live_cells = allowed_patterns[supplied_pattern]["input"]

# Process the input to respresent as grid of cells
grid_pattern = GameofLife.new

puts

puts "=========TEST OBSERVER PATTERN========="
grid_pattern.add_observer(GameofLifeUi.new)
# When addition of duplicate cell is attempted, observer will get notified
puts "=======END TEST OBSERVER PATTERN======="

puts

puts "=========GRID CORDINATES IN YAML========="
grid_live_cells.each do |grid_pos_xy|
# Initialize Live Cells and add to Grid
  puts %Q(#{grid_pos_xy.first}, #{grid_pos_xy.last})
  if grid_pos_xy.size == 2
    row = grid_pos_xy.first
    col = grid_pos_xy.last
    new_live_cell = Cell.new(row,col)
    new_live_cell.live
    grid_pattern << new_live_cell
  else
    puts "Please enter co-ordinates in x,y format e.g. 1,2"
  end
end
puts "=======END GRID CORDINATES IN YAML======="

puts

puts "=======INITIALIZE DEAD CELLS==========="
grid_pattern.grid_complete
puts "=======END INITIALIZE DEAD CELLS======="

puts

puts "=========MAZE INITIAL DISPLAY========="
grid_pattern.display
puts "=======END MAZE INITIAL DISPLAY======="


puts

puts "=========TEST VISITOR PATTERN========="
grid_pattern.grid_complete
cmds_to_exec = CompositeCommand.new
visitor_to_traverse = LifeVisitor.new
grid_pattern.advance(visitor_to_traverse, cmds_to_exec, grid_pattern)
cmds_to_exec.execute
puts "=======END TEST VISITOR PATTERN======="

puts

puts "=========MAZE DISPLAY AFTER VISITOR EXECUTION========="
grid_pattern.display
puts "=======END MAZE DISPLAY AFTER VISITOR EXECUTION======="


puts "=========TEST VISITOR PATTERN========="
grid_pattern.grid_complete
cmds_to_exec = CompositeCommand.new
visitor_to_traverse = LifeVisitor.new
grid_pattern.advance(visitor_to_traverse, cmds_to_exec, grid_pattern)
cmds_to_exec.execute
puts "=======END TEST VISITOR PATTERN======="

puts

puts "=========MAZE DISPLAY AFTER VISITOR EXECUTION========="
grid_pattern.display
puts "=======END MAZE DISPLAY AFTER VISITOR EXECUTION======="
