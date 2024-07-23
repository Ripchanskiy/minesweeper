# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Game do
  let(:width) { 5 }
  let(:height) { 5 }
  let(:holes_count) { 3 }
  subject(:game) { Game.new(width, height, holes_count) }

  describe '#initialize' do
    it 'validates grid parameters' do
      expect do
        Game.new(5, 5, -1)
      end.to raise_error(ArgumentError, 'All parameters must be valid integers and greater than 0')
    end
  end

  describe '#handle_status' do
    context 'when status is :within_bounds' do
      it 'prints invalid cell coordinates message' do
        expect do
          game.send(:handle_status,
                    Constants::Grid::REVEAL_STATUSES[:within_bounds])
        end.to output("Invalid cell coordinates.\n").to_stdout
      end
    end

    context 'when status is :already_revealed' do
      it 'prints cell already revealed message' do
        expect do
          game.send(:handle_status,
                    Constants::Grid::REVEAL_STATUSES[:already_revealed])
        end.to output("Cell already revealed.\n").to_stdout
      end
    end

    context 'when status is :has_hole' do
      it 'calls game_over' do
        expect(game).to receive(:game_over)
        game.send(:handle_status, Constants::Grid::REVEAL_STATUSES[:has_hole])
      end
    end

    context 'when status is :all_revealed' do
      it 'calls win_game' do
        expect(game).to receive(:win_game)
        game.send(:handle_status, Constants::Grid::REVEAL_STATUSES[:all_revealed])
      end
    end

    context 'when status is other' do
      it 'prints continue message' do
        expect { game.send(:handle_status, :other) }.to output("Continue on!\n").to_stdout
      end
    end
  end

  describe '#game_over' do
    it 'sets the game state to lost and prints game over message' do
      expect { game.send(:game_over) }.to change {
                                            game.instance_variable_get(:@game_state)
                                          }.from(Game::PLAY_MODE[:PLAYING]).to(Game::PLAY_MODE[:LOST])
      expect { game.send(:game_over) }.to output("Game Over! You hit a hole.\n").to_stdout
    end
  end

  describe '#win_game' do
    it 'sets the game state to won and prints congratulatory message' do
      expect { game.send(:win_game) }.to change {
                                           game.instance_variable_get(:@game_state)
                                         }.from(Game::PLAY_MODE[:PLAYING]).to(Game::PLAY_MODE[:WON])
      expect { game.send(:win_game) }.to output("Congratulate the winner!\n").to_stdout
    end
  end
end
