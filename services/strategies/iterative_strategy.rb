# frozen_string_literal: true

class IterativeStrategy < GridService
  def reveal_cell(x, y) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
    return REVEAL_STATUSES[:within_bounds] unless within_bounds?(x, y)

    cell = @grid[y][x]
    if cell[:revealed]
      REVEAL_STATUSES[:already_revealed]
    elsif cell[:has_hole]
      reveal_all_holes
      REVEAL_STATUSES[:has_hole]
    else
      if cell[:touching_holes].zero?
        # Iteratively reveal all neighboring cells if cell doesn't have touching_holes
        reveal_surrounding_cells(x, y) if cell[:touching_holes].zero?
      else
        on_reveal(cell)
      end

      all_cells_revealed? ? REVEAL_STATUSES[:all_revealed] : REVEAL_STATUSES[:revealed]
    end
  end

  private

  def reveal_surrounding_cells(x, y) # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize
    stack = [[x, y]]
    until stack.empty?
      cx, cy = stack.pop
      next unless within_bounds?(cx, cy)

      cell = @grid[cy][cx]
      next if cell[:revealed] || cell[:has_hole]

      on_reveal(cell)
      return if all_cells_revealed?

      next unless cell[:touching_holes].zero?

      DIRECTIONS.each do |dy, dx|
        nx = cx + dx
        ny = cy + dy
        stack.push([nx, ny]) if within_bounds?(nx, ny)
      end
    end
  end
end
