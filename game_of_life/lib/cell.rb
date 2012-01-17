class Cell
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end  

# To facilitate inlcude? function of array
  def ==(other_cell)
    return true if ((self.x == other_cell.x) && (self.y == other_cell.y))
    return false
  end

# Get all neighbours
  def all_neighbours
#   straight_line_neighbours are [1,0], [0,-1], [-1,0], [0,1]
#   diagonal_neighbours are [1,1], [1,-1], [-1,-1], [-1,1] 
    neighbouring_cells = []
    (-1).upto(1) do |offset_x|
      (-1).upto(1) do |offset_y|
#       Avoid [0,0] as self
        unless (offset_x==0 && offset_y==0)
          neighbouring_cells << Cell.new(x + offset_x,y + offset_y)
        end        
      end
    end   
    neighbouring_cells
  end

# Get all neighbours and compare with already alive cells in grid and increment if present
  def alive_neighbours(alive_cells_in_grid)
    alive_neighbours_count = 0
    all_neighbours.each do |a_neighbour|
      alive_neighbours_count += 1 if alive_cells_in_grid.include?(a_neighbour)      
    end
    alive_neighbours_count
  end

# TO-DO: Need to take in account those who are not live cells and also not part of neighbours of live cell .. someone in isolation
  def dead_neighbour?(all_neighbours_of_live_cell, alive_cells_in_grid)
    all_neighbours_of_live_cell.include?(self) && !alive_cells_in_grid.include?(self)
  end
end
