# frozen_string_literal: true

class IterativeStrategy
  include Constants::Grid
  def initialize(grid_service)
    @grid_service = grid_service
    @grid = grid_service.grid
  end

  def reveal_cell(x, y)
    reveal_cell_iterative(x, y)
  end

  private

  def reveal_cell_iterative(x, y)
    return REVEAL_STATUSES[:within_bounds] unless @grid_service.within_bounds?(x, y)

    cell = @grid[y][x]
    if cell[:revealed]
      REVEAL_STATUSES[:already_revealed]
    elsif cell[:has_hole]
      @grid_service.reveal_all_holes
      REVEAL_STATUSES[:has_hole]
    else
      reveal_surrounding_cells(x, y)
      @grid_service.all_cells_revealed? ? REVEAL_STATUSES[:all_revealed] : REVEAL_STATUSES[:revealed]
    end
  end

  def reveal_surrounding_cells(x, y) # rubocop:disable Metrics/PerceivedComplexity,  Metrics/AbcSize, Metrics/CyclomaticComplexity
    stack = [[x, y]]
    until stack.empty?
      cx, cy = stack.pop
      next unless @grid_service.within_bounds?(cx, cy)

      cell = @grid[cy][cx]
      next if cell[:revealed] || cell[:has_hole]

      @grid_service.on_reveal(cell)
      return if @grid_service.all_cells_revealed?

      next unless cell[:touching_holes].zero?

      DIRECTIONS.each do |dy, dx|
        nx = cx + dx
        ny = cy + dy
        stack.push([nx, ny]) if @grid_service.within_bounds?(nx, ny)
      end
    end
  end
end
