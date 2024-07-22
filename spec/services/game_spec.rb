# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Game do
  let(:width) { 5 }
  let(:height) { 5 }
  let(:holes_count) { 3 }
  subject(:game) { Game.new(width, height, holes_count) }

  describe '#initialize' do
    it 'validates grid parameters' do
      expect { Game.new(5, 5, -1) }.to raise_error(ArgumentError, "All parameters must be valid integers and greater than 0")
    end
  end
end
