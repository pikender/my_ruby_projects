class Rule4BackFromDeadExactly3LiveNeighbours < Rule
  def apply_rule(grid_pattern, next_gen_grid_pattern)
    modified_gen_grid_pattern = []
    all_neighbouring_dead_cells = get_neighbouring_dead_cells(grid_pattern)
    all_neighbouring_dead_cells.each do |cell|
      if back_from_dead(cell, grid_pattern) && !(modified_gen_grid_pattern.include?(cell))
        modified_gen_grid_pattern << cell
        next_gen_grid_pattern << cell
      end
    end
    modified_gen_grid_pattern    
  end

  private
    def back_from_dead(cell, grid_pattern)
      cell.alive_neighbours(grid_pattern) == 3
    end

    def get_neighbouring_dead_cells(grid_pattern)
      dead_neighbouring_cells = []
      grid_pattern.each do |cell|
        cell.all_neighbours.each do |neighbour_cell|
          unless grid_pattern.include?(neighbour_cell) && dead_neighbouring_cells.include?(neighbour_cell)
            dead_neighbouring_cells << neighbour_cell
          end
        end
      end 
      dead_neighbouring_cells
    end
end
