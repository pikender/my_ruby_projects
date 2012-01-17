#<internal:lib/rubygems/custom_require>:29:in `require': no such file to load -- grid.rb (LoadError)
#	from <internal:lib/rubygems/custom_require>:29:in `require'
#	from game_of_life.rb:2:in `<main>'

#<internal:lib/rubygems/custom_require>:29:in `require': no such file to load -- grid.rb (LoadError)
#	from <internal:lib/rubygems/custom_require>:29:in `require'
#	from game_of_life.rb:2:in `<main>'

require 'yaml'
Dir[File.dirname(__FILE__) + "/lib/**/*.rb"].each do |file|
  require file
end


unless ARGV.size == 1
  puts "Only one pattern allowed as of now." 
  exit(1)
end

allowed_patterns = YAML.load_file("lib/yaml_grids/grid.yml")

supplied_pattern = ARGV[0]
unless allowed_patterns.has_key?(supplied_pattern)
  puts "You entered --#{supplied_pattern}-- but Allowed Patterns are #{allowed_patterns.keys}"
  exit(1)
end

puts "Congratulations. You obeyed the program and program allows you to play in return. Hurray !!"

grid_live_cells = allowed_patterns[supplied_pattern]["input"]

## Process the input to respresent as grid of cells
grid_pattern = Grid.new

puts "=========GRID CORDINATES IN YAML========="
grid_live_cells.each do |grid_pos_xy|
# Initialize Live Cells and add to Grid
  puts %Q(#{grid_pos_xy.first}, #{grid_pos_xy.last})
  if grid_pos_xy.size == 2
    grid_pattern << Cell.new(grid_pos_xy.first,grid_pos_xy.last)  
  else
    puts "Please enter co-ordinates in x,y format e.g. 1,2"
  end
end
puts "=======END GRID CORDINATES IN YAML======="

puts

alive_cells_now = grid_pattern.cells

# Get the ticker to apply rules
ticker = Ticker.new

[Rule1LonelyOneOrNoLiveNeighbour, Rule2CrowdedFourOrMoreLiveNeighbours, Rule3Unchanged2Or3LiveNeighbours, Rule4BackFromDeadExactly3LiveNeighbours].each do |rule|
  ticker << rule.new
end

next_gen_grid_pattern = Grid.new
ticker.tick(grid_pattern, next_gen_grid_pattern)

puts "=========GRID BEFORE TICK========="
grid_pattern.display
puts "=======END GRID BEFORE TICK======="

puts

puts "=========GRID AFTER TICK========="
next_gen_grid_pattern.display
puts "=======END GRID AFTER TICK======="

