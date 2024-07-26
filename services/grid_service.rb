# frozen_string_literal: true

class GridService
  include Constants::Grid

  attr_reader :grid, :hole_positions

  def initialize(height, width, holes_count)
    @height = height
    @width = width
    @holes_count = holes_count
    @cells_without_holes_count = (width * height) - holes_count
    validate_grid_params

    @revealed_cells_count = 0
    @grid = initialize_grid
    @hole_positions = generate_hole_positions
    place_holes
  end

  def reveal_cell(x, y) # rubocop:disable Metrics/AbcSize
    return REVEAL_STATUSES[:within_bounds] unless within_bounds?(x, y)

    cell = @grid[y][x]
    if cell[:revealed]
      REVEAL_STATUSES[:already_revealed]
    elsif cell[:has_hole]
      reveal_all_holes
      REVEAL_STATUSES[:has_hole]
    else
      cell[:revealed] = true
      @revealed_cells_count += 1
      return REVEAL_STATUSES[:all_revealed] if all_cells_revealed?

      # Recursively reveal all neighboring cells if cell doesn't have touching_holes
      reveal_surrounding_cells(x, y) if cell[:touching_holes].zero?
      REVEAL_STATUSES[:revealed]
    end
  end

  private

  def initialize_grid
    # Initialize a 2D array (grid) with a specific default state for each cell
    # dup used for shallow copy of `CELL` obj
    Array.new(@height) { Array.new(@width) { DEFAULT_CELL_STATE.dup } }
  end

  def generate_hole_positions
    # Generate all possible (x, y) pairs for the grid. [[0, 0], [0, 1], [0, 2], ...]
    all_positions = (0...@height).to_a.product((0...@width).to_a)
    all_positions.sample(@holes_count)
  end

  def place_holes
    @hole_positions.each do |y, x|
      @grid[y][x][:has_hole] = true
      update_surrounding_holes(x, y)
    end
  end

  def all_cells_revealed?
    @revealed_cells_count == @cells_without_holes_count
  end

  def reveal_all_holes
    @hole_positions.each do |y, x|
      @grid[y][x][:revealed] = true
    end
  end

  def on_reveal(cell)
    cell[:revealed] = true
    @revealed_cells_count += 1
  end

  def update_surrounding_holes(x, y)
    DIRECTIONS.each do |dy, dx|
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

  def validate_grid_params
    # Validate max holes count
    raise ArgumentError, "Cells without holes can't be <= 0" if @cells_without_holes_count <= 0

    [@width, @height, @holes_count].each do |param|
      raise ArgumentError, 'All parameters must be valid integers and greater than 0' if param <= 0
    end
  end
end
