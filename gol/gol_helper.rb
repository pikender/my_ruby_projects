require 'yaml'
require './lib/subject.rb'
require './lib/game_of_life.rb'
require './lib/cell.rb'
#State Pattern
require './lib/cell_state.rb'
require './lib/alive_state.rb'
require './lib/dead_state.rb'

#Observer Pattern
require './lib/game_of_life_ui.rb'

#Command Pattern
require './lib/command.rb'
require './lib/composite_command.rb'
require './lib/life_command.rb'
require './lib/live_command.rb'
require './lib/die_command.rb'

#Visitor Pattern
require './lib/life_visitor.rb'
