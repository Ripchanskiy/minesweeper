# frozen_string_literal: true

RSpec.shared_examples 'a strategy' do
  let(:height) { 5 }
  let(:width) { 5 }
  let(:holes_count) { 3 }

  describe '#reveal_cell' do
    context 'when the cell is within bounds' do
      # Exclude positions with holes to ensure the cell does not have a hole
      let(:x) { ((0...width).to_a - grid_service.hole_positions.map { |_, x| x }).sample }
      let(:y) { ((0...height).to_a - grid_service.hole_positions.map { |y, _| y }).sample }

      it 'reveals the cell' do
        strategy.reveal_cell(x, y)
        expect(grid_service.grid[y][x][:revealed]).to be true
      end

      it 'returns :already_revealed if the cell is already revealed' do
        strategy.reveal_cell(x, y)
        status = strategy.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:already_revealed])
      end

      it 'returns :has_hole if the cell has a hole' do
        grid_service.grid[y][x][:has_hole] = true
        status = strategy.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:has_hole])
      end

      it 'returns :all_revealed if all non-hole cells are revealed' do
        allow(grid_service).to receive(:all_cells_revealed?).and_return(true)
        status = strategy.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:all_revealed])
      end

      it 'returns :revealed if the cell is successfully revealed' do
        status = strategy.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:revealed])
      end
    end

    context 'when the cell is out of bounds' do
      let(:x) { -1 }
      let(:y) { -1 }

      it 'returns :within_bounds' do
        status = strategy.reveal_cell(x, y)
        expect(status).to eq(Constants::Grid::REVEAL_STATUSES[:within_bounds])
      end
    end
  end
end
