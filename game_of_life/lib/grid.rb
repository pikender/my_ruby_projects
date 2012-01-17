class Grid
  attr_accessor :cells

  def initialize
    @cells = []
  end

#game_of_life.rb:37:in `block in <main>': undefined method `<<' for #<Grid:0x9ea8388 @cells=[]> (NoMethodError)
#	from game_of_life.rb:33:in `each'
#	from game_of_life.rb:33:in `<main>'
  def <<(cell)
    unless @cells.include?(cell)
      @cells << cell
    else
      puts "DEBUG - Already present in grid #{cell.inspect}"
      "Already present in grid #{cell.inspect}"    
    end
  end

  def remove_cell(cell)
    @cells.delete(cell)
  end

  def two_d_display
    two_d_display = []
    (min_xy.first).upto(max_xy.first) do |x|
      row_display_str = []
      (min_xy.last).upto(max_xy.last) do |y|
        current_cell = Cell.new(x,y)
        if @cells.include?(current_cell)
          row_display_str << "X"  
        else
          row_display_str << "-"  
        end
      end
      two_d_display << row_display_str
    end
    two_d_display
  end

  def display
    two_d_display.each do |row|
      row.each do |col|    
        print "#{col} \t"
      end
      print "\n"  
    end  
  end


  private

    def debug_xy(x,y)
      print "#{x}, #{y}"
    end 
# Setting first value as min or max can be refactored
    def max_xy
      temp_max_x = 0
      temp_max_x = @cells.first.x unless @cells.first.nil?

      temp_max_y = 0
      temp_max_y = @cells.first.y unless @cells.first.nil?

      @cells.each do |cell|
        temp_max_x = cell.x if cell.x > temp_max_x
        temp_max_y = cell.y if cell.y > temp_max_y
      end
      [temp_max_x,temp_max_y]
    end

    def min_xy
      temp_min_x = -1000000
      temp_min_x = @cells.first.x unless @cells.first.nil?

      temp_min_y = -1000000
      temp_min_y = @cells.first.y unless @cells.first.nil?

      @cells.each do |cell|
        temp_min_x = cell.x if cell.x < temp_min_x
        temp_min_y = cell.y if cell.y < temp_min_y
      end
      [temp_min_x,temp_min_y]
    end
end
