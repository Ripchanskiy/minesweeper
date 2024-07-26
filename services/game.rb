# frozen_string_literal: true

class Game
  include Constants::Grid
  include InputHelper

  PLAY_MODE = { PLAYING: 0, LOST: 1, WON: 2 }.freeze

  def initialize(width, height, holes_count, strategy_class)
    @width = width.to_i
    @height = height.to_i
    @holes_count = holes_count.to_i
    @game_state = PLAY_MODE[:PLAYING]
    @cells_without_holes_count = (width * height) - holes_count
    @grid_service = GridService.new(@height, @width, @holes_count)
    @strategy = strategy_class.new(@grid_service)
  end

  def start
    while @game_state == PLAY_MODE[:PLAYING]
      x = get_valid_integer_input('Enter X').to_i
      y = get_valid_integer_input('Enter Y').to_i

      status = @strategy.reveal_cell(x, y)
      handle_status(status)
      print_grid(@grid_service.grid)
    end
  end

  private

  def handle_status(status)
    case status
    when REVEAL_STATUSES[:within_bounds]
      print_message('Invalid cell coordinates.')
    when REVEAL_STATUSES[:already_revealed]
      print_message('Cell already revealed.')
    when REVEAL_STATUSES[:has_hole]
      game_over
    when REVEAL_STATUSES[:all_revealed]
      win_game
    else
      print_message('Continue on!')
    end
  end

  def game_over
    @game_state = PLAY_MODE[:LOST]
    print_message('Game Over! You hit a hole.')
  end

  def win_game
    @game_state = PLAY_MODE[:WON]
    print_message('Congratulate the winner!')
  end
end
