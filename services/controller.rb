# frozen_string_literal: true

class Controller
  include Constants::Grid
  include InputHelper

  def init_game
    width = get_valid_integer_input('Enter the width of the grid: ', min_value: MIN_WIDTH).to_i
    height = get_valid_integer_input('Enter the height of the grid: ', min_value: MIN_HEIGHT).to_i
    max_holes = (width * height) - MIN_HOLES_TO_GRID_GAP
    holes_count = get_valid_integer_input('Enter the number of holes: ', min_value: 1, max_value: max_holes).to_i

    strategy = choose_strategy
    game = Game.new(width, height, holes_count, strategy)
    game.start
  end

  private

  def choose_strategy
    strategy_choice = get_valid_integer_input('Choose strategy: 1 for Recursive, 2 for Iterative', min_value: 1,
                                                                                                   max_value: 2)
    strategy_choice == 1 ? RecursiveStrategy : IterativeStrategy
  end
end
