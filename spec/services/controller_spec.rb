# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Controller do
  let(:controller) { Controller.new }

  before do
    allow(controller).to receive(:get_valid_integer_input)
      .with('Enter the width of the grid: ', min_value: 5)
      .and_return('10')
    allow(controller).to receive(:get_valid_integer_input)
      .with('Enter the height of the grid: ', min_value: 5)
      .and_return('10')
    allow(controller).to receive(:get_valid_integer_input)
      .with('Enter the number of holes: ', min_value: 1, max_value: 75)
      .and_return('15')
    allow(controller).to receive(:get_valid_integer_input)
      .with('Choose strategy: 1 for Recursive, 2 for Iterative', min_value: 1, max_value: 2)
      .and_return(1)
  end

  describe '#init_game' do
    it 'prompts for grid width and height, and number of holes' do
      expect(controller).to receive(:get_valid_integer_input)
        .with('Enter the width of the grid: ', min_value: 5)
        .and_return('10')
      expect(controller).to receive(:get_valid_integer_input)
        .with('Enter the height of the grid: ', min_value: 5)
        .and_return('10')
      expect(controller).to receive(:get_valid_integer_input)
        .with('Enter the number of holes: ', min_value: 1, max_value: 95)
        .and_return('15')
      expect(controller).to receive(:get_valid_integer_input)
        .with('Choose strategy: 1 for Recursive, 2 for Iterative', min_value: 1, max_value: 2)
        .and_return(1)

      expect(Game).to receive(:new).with(10, 10, 15, RecursiveStrategy).and_call_original
      expect_any_instance_of(Game).to receive(:start)

      controller.init_game
      controller
    end
  end
end
