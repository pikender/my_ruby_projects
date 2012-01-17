class Rule2CrowdedFourOrMoreLiveNeighbours < Rule
  def apply_rule(grid_pattern, next_gen_grid_pattern)
    grid_pattern.each do |cell|
      if die_crowded(cell, grid_pattern)
        next_gen_grid_pattern.remove_cell(cell)
      end
    end
  end

  private
    def die_crowded(cell, grid_pattern)
      cell.alive_neighbours(grid_pattern) > 3
    end
end

