# frozen_string_literal: true

class Controller
  include Constants::Grid
  include InputHelper

  def init_game
    width = get_valid_integer_input('Enter the width of the grid: ', min_value: MIN_WIDTH).to_i
    height = get_valid_integer_input('Enter the height of the grid: ', min_value: MIN_HEIGHT).to_i
    max_holes = (width * height) - MIN_HOLES_TO_GRID_GAP
    holes_count = get_valid_integer_input('Enter the number of holes: ', min_value: 1, max_value: max_holes).to_i

    game = Game.new(width, height, holes_count)
    game.start
  end
end
