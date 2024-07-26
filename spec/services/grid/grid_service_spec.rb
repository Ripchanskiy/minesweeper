# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe GridService do
  let(:height) { 5 }
  let(:width) { 5 }
  let(:holes_count) { 3 }
  let(:grid_service) { described_class.new(height, width, holes_count) }

  describe '#initialize' do
    it 'initializes the grid with the correct dimensions' do
      expect(grid_service.grid.size).to eq(height)
      expect(grid_service.grid.all? { |row| row.size == width }).to be true
    end

    it 'initializes the correct number of holes' do
      hole_count = grid_service.grid.flatten.count { |cell| cell[:has_hole] }
      expect(hole_count).to eq(holes_count)
      expect(grid_service.hole_positions.count).to eq(holes_count)
    end

    it 'places holes in the correct positions' do
      hole_positions = grid_service.hole_positions
      hole_positions.each do |y, x|
        expect(grid_service.grid[y][x][:has_hole]).to be true
      end
    end
  end

  describe '#reveal_cell' do
    it 'raises NotImplementedError when called' do
      expect do
        grid_service.reveal_cell(0,
                                 0)
      end.to raise_error(NotImplementedError, 'This method should be implemented by the strategy classes')
    end
  end

  describe '#within_bounds?' do
    it 'returns true if the cell is within bounds' do
      expect(grid_service.send(:within_bounds?, 2, 2)).to be true
    end

    it 'returns false if the cell is out of bounds' do
      expect(grid_service.send(:within_bounds?, -1, -1)).to be false
      expect(grid_service.send(:within_bounds?, width, height)).to be false
    end
  end

  describe '#all_cells_revealed?' do
    it 'returns true when all non-hole cells are revealed' do
      grid_service.grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          grid_service.send(:on_reveal, cell) unless grid_service.hole_positions.include?([y, x])
        end
      end

      expect(grid_service.all_cells_revealed?).to be true
    end

    it 'returns false when not all non-hole cells are revealed' do
      # rubocop:disable Lint/UnreachableLoop
      grid_service.grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          unless grid_service.hole_positions.include?([y, x])
            grid_service.send(:on_reveal, cell)
            break
          end
        end
        break
      end
      # rubocop:enable Lint/UnreachableLoop
      expect(grid_service.all_cells_revealed?).to be false
    end
  end

  describe '#reveal_all_holes' do
    it 'reveals all cells with holes' do
      grid_service.reveal_all_holes
      hole_positions_revealed = grid_service.hole_positions.all? do |y, x|
        grid_service.grid[y][x][:revealed]
      end
      expect(hole_positions_revealed).to be true
    end
  end

  describe '#on_reveal' do
    it 'marks a cell as revealed and increments the revealed_cells_count' do
      cell = grid_service.grid[2][2]
      expect { grid_service.on_reveal(cell) }.to change {
                                                   grid_service.instance_variable_get(:@revealed_cells_count)
                                                 }.by(1)
      expect(cell[:revealed]).to be true
    end
  end

  describe '#initialize_grid' do
    it 'initializes a grid with default cell states' do
      grid = grid_service.send(:initialize_grid)
      expect(grid.size).to eq(height)
      expect(grid.first.size).to eq(width)
      expect(grid.flatten.all? { |cell| cell == Constants::Grid::DEFAULT_CELL_STATE }).to be true
    end
  end

  describe '#generate_hole_positions' do
    it 'generates the correct number of hole positions' do
      hole_positions = grid_service.send(:generate_hole_positions)
      expect(hole_positions.size).to eq(holes_count)
      expect(grid_service.grid.flatten.count { |s| s[:has_hole] }).to eq(holes_count)
    end
  end

  describe '#place_holes' do
    it 'places holes in the grid' do
      grid_service.send(:place_holes)
      hole_positions = grid_service.hole_positions
      grid_holes = grid_service.grid.flatten.count { |cell| cell[:has_hole] }
      expect(grid_holes).to eq(hole_positions.count)
      hole_positions.each do |y, x|
        expect(grid_service.grid[y][x][:has_hole]).to be true
      end
    end
  end

  describe '#update_surrounding_holes' do
    it 'updates the touching holes count for surrounding cells' do
      grid_service.send(:update_surrounding_holes, 2, 2)

      surrounding_cells = Constants::Grid::DIRECTIONS.map { |dy, dx| [2 + dy, 2 + dx] }
                                                     .select { |y, x| grid_service.send(:within_bounds?, x, y) }

      hole_positions = grid_service.hole_positions

      surrounding_cells.reject! { |y, x| hole_positions.include?([y, x]) }

      surrounding_cells.each do |y, x|
        expect(grid_service.grid[y][x][:touching_holes]).to be >= 1
      end
    end
  end
end
