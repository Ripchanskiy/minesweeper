# frozen_string_literal: true

module Constants
  module Grid
    REVEAL_STATUSES = {
      within_bounds: :within_bounds,
      already_revealed: :already_revealed,
      has_hole: :has_hole,
      all_revealed: :all_revealed,
      revealed: :revealed
    }.freeze

    MIN_WIDTH = 5
    MIN_HEIGHT = 5
    MIN_HOLES_TO_GRID_GAP = 5

    DEFAULT_CELL_STATE = { has_hole: false, revealed: false, touching_holes: 0 }.freeze

    # This array contains all possible directions (vector offsets) to the neighboring cells.
    # Directions are represented as pairs (dy, dx), where:
    # - `dy` is the offset along the Y axis
    # - `dx` is the offset along the X axis.
    DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze
  end
end
