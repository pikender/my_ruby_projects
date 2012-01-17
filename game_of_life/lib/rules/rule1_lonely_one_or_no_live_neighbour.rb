class Rule1LonelyOneOrNoLiveNeighbour < Rule
  def apply_rule(grid_pattern, next_gen_grid_pattern)
    grid_pattern.each do |cell|
      if die_lonely(cell, grid_pattern)
        next_gen_grid_pattern.remove_cell(cell)
      end
    end
  end

  private
    def die_lonely(cell, grid_pattern)
      cell.alive_neighbours(grid_pattern) < 2
    end
end

