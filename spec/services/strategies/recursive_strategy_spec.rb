# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe RecursiveStrategy do
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
    end
  end

  describe '#reveal_cell' do
    context 'when the cell is within bounds' do
      # Exclude positions with holes to ensure the cell does not have a hole
      let(:x) { ((0...width).to_a - grid_service.hole_positions.map { |_, x| x }).sample }
      let(:y) { ((0...height).to_a - grid_service.hole_positions.map { |y, _| y }).sample }

      it 'reveals the cell' do
        grid_service.reveal_cell(x, y)
        expect(grid_service.grid[y][x][:revealed]).to be true
      end

      it 'returns :already_revealed if the cell is already revealed' do
        grid_service.reveal_cell(x, y)
        status = grid_service.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:already_revealed])
      end

      it 'returns :has_hole if the cell has a hole' do
        grid_service.grid[y][x][:has_hole] = true
        status = grid_service.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:has_hole])
      end

      it 'returns :all_revealed if all non-hole cells are revealed' do
        allow(grid_service).to receive(:all_cells_revealed?).and_return(true)
        status = grid_service.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:all_revealed])
      end

      it 'returns :revealed if the cell is successfully revealed' do
        status = grid_service.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:revealed])
      end
    end

    context 'when the cell is out of bounds' do
      let(:x) { -1 }
      let(:y) { -1 }

      it 'returns :within_bounds' do
        status = grid_service.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:within_bounds])
      end
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
end
