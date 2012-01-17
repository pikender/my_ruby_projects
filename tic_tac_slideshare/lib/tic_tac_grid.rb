class TicTacGrid
  def initialize(tic_tac_grid)
    sanitize_grid(tic_tac_grid)
    @tic_tac_grid = tic_tac_grid
    @grid_dim = Math.sqrt(tic_tac_grid.size).to_i
    raise "Not a perfect square #{@grid_dim} * #{@grid_dim} NOT EQUAL TO #{tic_tac_grid.size}" unless ((@grid_dim * @grid_dim) == tic_tac_grid.size)
  end

  def empty_cell_present?
    @tic_tac_grid.scan(/-/).size > 0
  end

  def rows_match?(ch)
    logic_com?(find_row_straights, ch)
  end

  def cols_match?(ch)
    logic_com?(find_col_straights, ch)
  end

  def diagonals_match?(ch)
    logic_com?(find_diagonals, ch)
  end

  def logic_com?(arrays_to_match, ch)
    found_pattern = false
    arrays_to_match.each do |t|
      winner = true
      t.each do |u|
        winner = winner && @tic_tac_grid[u].chr.eql?(ch)
      end
      if winner
        found_pattern = true
        break
      end
    end
    return found_pattern
  end

  def win?(ch)
    return true if rows_match?(ch) || cols_match?(ch) || diagonals_match?(ch)
    return false
  end

  def continue_playing?
   !(win?('X') || win?('O')) && empty_cell_present?
  end

  def stalemate?
   !(win?('X') || win?('O')) && !empty_cell_present?
  end

  def find_row_straights
    ## Iterate through 0 to n-1 do i
    ## Create Arrays for i * n to ((i + 1) * n) - 1
    n = @grid_dim
    row_arr = []
    0.upto(n - 1) do |i|
      temp = []
      (i * n).upto(((i + 1) * n) - 1) do |k|
        temp << k
      end
      row_arr << temp
    end
    row_arr
  end

  def find_col_straights
    ## Iterate through 0 to n-1 do i
    ## Create Arrays for i to (n * n) -1 in increments of n
    n = @grid_dim
    col_arr = []
    0.upto(n - 1) do |i|
      temp = []
      (i).step(((n * n) - 1), n) do |k|
        temp << k
      end
      col_arr << temp
    end
    col_arr
  end

  def find_diagonals
    ## Iterate through 1 to n do i
    ## (i + (i - 1) * n) - 1
    ## ((i * n) - (i-1)) - 1
    n = @grid_dim
    diag_arr_st = []
    diag_arr_op = []
    1.upto(n) do |i|
      diag_arr_st << (i + (i - 1) * n) - 1
      diag_arr_op << ((i * n) - (i-1)) - 1
    end

    diag_arr = [diag_arr_st, diag_arr_op]
  end

  private

    def show_diag_graphic_rep(diag_arr)
      n = @grid_dim
      a = Array.new(n*n,'-')
      diag_arr.flatten.each do |x|
        a[x] = "*"
      end
      a.each_with_index do |x,i|
        print "#{x}\t"
        print "\n" if (((i + 1) % n) == 0)
      end    
    end
    
    def sanitize_grid(tic_tac_grid)
      tic_tac_grid.each_char do |t|
        raise "Invalid Letter (#{t}) Present" unless ['X', 'O', '-'].include?(t)
      end
    end
end
