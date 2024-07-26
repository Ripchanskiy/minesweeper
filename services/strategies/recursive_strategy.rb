# frozen_string_literal: true

class RecursiveStrategy < GridService
  def reveal_cell(x, y) # rubocop:disable Metrics/AbcSize
    return REVEAL_STATUSES[:within_bounds] unless within_bounds?(x, y)

    cell = @grid[y][x]
    if cell[:revealed]
      REVEAL_STATUSES[:already_revealed]
    elsif cell[:has_hole]
      reveal_all_holes
      REVEAL_STATUSES[:has_hole]
    else
      on_reveal(cell)
      return REVEAL_STATUSES[:all_revealed] if all_cells_revealed?

      # Recursively reveal all neighboring cells if cell doesn't have touching_holes
      reveal_surrounding_cells(x, y) if cell[:touching_holes].zero?
      REVEAL_STATUSES[:revealed]
    end
  end

  private

  def reveal_surrounding_cells(x, y)
    DIRECTIONS.each do |dy, dx|
      # For each direction, the `coordinates of the neighboring cell` (ny, nx) are calculated
      # by adding the offsets `dy` and `dx` to the current cell coordinates (y, x)
      nx = x + dx
      ny = y + dy
      # Ensure the neighboring cell (nx, ny) is within the grid boundaries and doesn't have a hole
      next unless within_bounds?(nx, ny)

      next_cell = @grid[ny][nx]
      # Ignore holes and already revealed cells
      reveal_cell(nx, ny) unless next_cell[:revealed] || next_cell[:has_hole]
    end
  end
end
