class Rule3Unchanged2Or3LiveNeighbours < Rule
  def apply_rule(grid_pattern, next_gen_grid_pattern)
    grid_pattern.each do |cell|
      if live_unchanged(cell, grid_pattern)
        next_gen_grid_pattern << cell
      end
    end
  end

  private
    def live_unchanged(cell, grid_pattern)
      cell.alive_neighbours(grid_pattern) > 1 && cell.alive_neighbours(grid_pattern) < 4
    end
end
