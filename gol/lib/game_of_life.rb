class GameofLife
  include Subject

  attr_accessor :cells

  def initialize
    @cells = []
    super() 
  end

  def <<(cell)
    unless @cells.include?(cell)
      @cells << cell
    else
#      Testing Observer Pattern
      notify_observers
      "Already present in grid #{cell.inspect}"    
    end
  end

  def remove_cell(cell)
    @cells.delete(cell)
  end

  def advance(life_visitor, composite_command, game_of_life)
    @cells.each do |c|
      c.accept(life_visitor, composite_command, game_of_life)
    end
  end

  def two_d_display
    x_width = (max_xy.first - min_xy.first) + 1
    y_width = (max_xy.last - min_xy.last) + 1

    two_d_display_a = Array.new(x_width) { Array.new(y_width, "0")}

    @cells.each do |cell|
      two_d_display_a[cell.row][cell.col] = cell.print_char
    end  
    two_d_display_a
  end

  def display
    two_d_display.each do |x|
      x.each do |y|    
        print "#{y} \t"
      end
      print "\n"  
    end  
  end

  def grid_complete
    find_dead_neighbours.each do |dn|
      if dn.size == 2
        new_dead_cell = Cell.new(dn.first,dn.last)
        new_dead_cell.die
        self << new_dead_cell
      else
        puts "Please enter co-ordinates in x,y format e.g. 1,2"
      end
    end
  end

  def find_dead_neighbours
    total_neighbour_list = []   
    alive_cells_xy = []
    @cells.each do |cell|
      if cell.isAlive?
        cell.neighbours_xy.each do |cn|
          total_neighbour_list << cn
        end
        alive_cells_xy << [cell.row, cell.col]
      end
    end  
    dead_neighbour_list = total_neighbour_list.collect {|c| c unless alive_cells_xy.include?(c)}.compact
  end

  def to_debug
    desc = ""
    @cells.each do |cell|
      desc += "#{cell.to_debug} \t"
    end  
    desc
  end


  private

# Setting first value as min or max can be refactored
    def max_xy
      temp_max_x = -1000000
      temp_max_x = @cells.first.row unless @cells.first.nil?

      temp_max_y = -1000000
      temp_max_y = @cells.first.col unless @cells.first.nil?

      @cells.each do |cell|
        temp_max_x = cell.row if cell.row > temp_max_x
        temp_max_y = cell.col if cell.col > temp_max_y
      end
      [temp_max_x,temp_max_y]
    end

    def min_xy
      temp_min_x = 1000000
      temp_min_x = @cells.first.row unless @cells.first.nil?

      temp_min_y = 1000000
      temp_min_y = @cells.first.col unless @cells.first.nil?

      @cells.each do |cell|
        temp_min_x = cell.row if cell.row < temp_min_x
        temp_min_y = cell.col if cell.col < temp_min_y
      end
      [temp_min_x,temp_min_y]
    end
end
