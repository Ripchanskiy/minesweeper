# frozen_string_literal: true

require_relative 'helpers/input_helper'

class Game
  include InputHelper

  PLAY_MODE = { PLAYING: 0, LOST: 1, WON: 2 }.freeze
  DEFAULT_CELL_STATE = { has_hole: false, revealed: false, touching_holes: 0 }.freeze

  # This array contains all possible directions (vector offsets) to the neighboring cells.
  # Directions are represented as pairs (dy, dx), where:
  # - `dy` is the offset along the Y axis
  # - `dx` is the offset along the X axis.
  DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  def initialize(width, height, holes_count)
    @width = width.to_i
    @height = height.to_i
    @holes_count = holes_count.to_i
    @game_state = PLAY_MODE[:PLAYING]
    @cells_without_holes_count = (width * height) - holes_count
    @revealed_cells_count = 0

    validate_grid_params
    initialize_grid
    place_holes
  end

  def start
    while @game_state == PLAY_MODE[:PLAYING]
      print_grid
      x = get_valid_input("Enter X").to_i
      y = get_valid_input("Enter Y").to_i

      if within_bounds?(x, y)
        reveal_cell(x, y)
      else
        print_message("Invalid cell coordinates.")
        print_grid
      end

      print_message("Continue on!") if @game_state == PLAY_MODE[:PLAYING]
    end
  end

  private

  def validate_grid_params
    # Validate max holes count
    raise ArgumentError, "Cells without holes can't be <= 0" if @cells_without_holes_count <= 0

    [@width, @height, @holes_count].each do |param|
      raise ArgumentError, "All parameters must be valid integers and greater than 0" if param <= 0
    end
  end

  def initialize_grid
    # Initialize a 2D array (grid) with a specific default state for each cell
    # dup used for shallow copy of `CELL` obj
    @grid = Array.new(@height) { Array.new(@width) { DEFAULT_CELL_STATE.dup } }
  end

  def place_holes
    hole_positions.each do |y, x|
      @grid[y][x][:has_hole] = true
      update_surrounding_holes(x, y)
    end
  end

  def hole_positions
    # Generate all possible (x, y) pairs for the grid. [[0, 0], [0, 1], [0, 2], ...]
    all_positions = (0...@height).to_a.product((0...@width).to_a)
    @hole_positions ||= all_positions.sample(@holes_count)
  end

  def update_surrounding_holes(x, y)
    DIRECTIONS.each do |dx, dy|
      # For each direction, the `coordinates of the neighboring cell` (ny, nx) are calculated
      # by adding the offsets `dy` and `dx` to the current cell coordinates (y, x)
      nx = x + dx
      ny = y + dy
      # Ensure the neighboring cell (nx, ny) is within the grid boundaries and doesn't have a hole
      if within_bounds?(nx, ny) && !@grid[ny][nx][:has_hole]
        # Increment the count of touching holes for the neighboring cell (ny, nx)
        @grid[ny][nx][:touching_holes] += 1
      end
    end
  end

  # Check if cell (x, y) is within the grid boundaries
  def within_bounds?(x, y)
    x.between?(0, @width - 1) && y.between?(0, @height - 1)
  end

  def reveal_cell(x, y)
    cell = @grid[y][x]
    if cell[:revealed]
      print_message("Cell already revealed.")
    elsif cell[:has_hole]
      game_over
    else
      cell[:revealed] = true
      @revealed_cells_count += 1
      return win_game if @revealed_cells_count == @cells_without_holes_count

      # Recursively reveal all neighboring cells if cell doesn't have touching_holes
      reveal_surrounding_cells(x, y) if cell[:touching_holes].zero?
    end
  end

  def game_over
    reveal_all_holes
    @game_state = PLAY_MODE[:LOST]
    print_grid
    print_message("Game Over! You hit a hole.")
  end

  def win_game
    @game_state = PLAY_MODE[:WON]
    print_grid
    print_message("Congratulate the winner!")
  end

  def reveal_all_holes
    hole_positions.each do |x, y|
      @grid[x][y][:revealed] = true
    end
  end

  def reveal_surrounding_cells(x, y)
    DIRECTIONS.each do |dx, dy|
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

  def print_message(message)
    puts message
  end

  def print_grid
    @grid.each do |row|
      row.each do |cell|
        if cell[:revealed]
          if cell[:has_hole]
            print "H "
          else
            print "#{cell[:touching_holes]} "
          end
        else
          print ". "
        end
      end
      puts
    end
  end
end

class Controller
  include InputHelper

  def init_game
    width = get_valid_input("Enter the width of the grid: ", min_value: MIN_WIDTH).to_i
    height = get_valid_input("Enter the height of the grid: ", min_value: MIN_HEIGHT).to_i
    max_holes = (width * height) - MIN_HOLES_TO_GRID_GAP
    holes_count = get_valid_input("Enter the number of holes: ", min_value: 1, max_value: max_holes).to_i

    game = Game.new(width, height, holes_count)
    game.start
  end
end

controller = Controller.new
controller.init_game
