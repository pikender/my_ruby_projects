class Cell
  attr_accessor :row, :col, :cell_state , :neighbours_xy

  def initialize(row, col)
    @row = row
    @col = col
    @cell_state = CellState.new
    @neighbours_xy = initialize_neighbours_xy
  end

  def initialize_neighbours_xy
    neighbours_xy = []
    (-1).upto(1) do |offset_x|
      (-1).upto(1) do |offset_y|
#       Avoid [0,0] as self
        unless (offset_x==0 && offset_y==0)
          neighbours_xy << [row + offset_x,col + offset_y]
        end        
      end
    end 
    neighbours_xy  
  end

# To facilitate inlcude? function of array
  def ==(other_cell)
    return true if ((self.row == other_cell.row) && (self.col == other_cell.col))
    return false
  end

  def is_neighbour?(other_cell)
    neighbour_xy = [other_cell.row, other_cell.col]
    return true if (@neighbours_xy.include?(neighbour_xy))
    return false
  end

  def is_alive_neighbour?(other_cell)
    return is_neighbour?(other_cell) && other_cell.isAlive?
  end

  def live
    @cell_state = @cell_state.live
  end

  def die
    @cell_state = @cell_state.die
  end

  def toggle
    @cell_state = @cell_state.toggle
  end

  def isAlive?
    return @cell_state.isAlive?
  end

  def print_char
    return @cell_state.print_char
  end

  def accept(life_visitor, cmds, game_of_life)
    @cell_state.accept(life_visitor, cmds, game_of_life, self)
  end

  def to_debug
    "Cell: row=#{row}, col=#{col}, state=#{cell_state.isAlive?}"
  end
end
