# frozen_string_literal: true

class RecursiveStrategy
  include Constants::Grid
  def initialize(grid_service)
    @grid_service = grid_service
    @grid = grid_service.grid
  end

  def reveal_cell(x, y)
    reveal_cell_recursive(x, y)
  end

  private

  def reveal_cell_recursive(x, y) # rubocop:disable Metrics/AbcSize
    return REVEAL_STATUSES[:within_bounds] unless @grid_service.within_bounds?(x, y)

    cell = @grid[y][x]
    if cell[:revealed]
      REVEAL_STATUSES[:already_revealed]
    elsif cell[:has_hole]
      @grid_service.reveal_all_holes
      REVEAL_STATUSES[:has_hole]
    else
      @grid_service.on_reveal(cell)
      return REVEAL_STATUSES[:all_revealed] if @grid_service.all_cells_revealed?

      # Recursively reveal all neighboring cells if cell doesn't have touching_holes
      reveal_surrounding_cells(x, y) if cell[:touching_holes].zero?
      @grid_service.all_cells_revealed? ? REVEAL_STATUSES[:all_revealed] : REVEAL_STATUSES[:revealed]
    end
  end

  def reveal_surrounding_cells(x, y)
    DIRECTIONS.each do |dy, dx|
      nx = x + dx
      ny = y + dy
      next unless @grid_service.within_bounds?(nx, ny)

      next_cell = @grid[ny][nx]
      reveal_cell_recursive(nx, ny) unless next_cell[:revealed] || next_cell[:has_hole]
    end
  end
end
