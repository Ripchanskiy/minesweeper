# frozen_string_literal: true

require_relative '../spec_helper'

class TestInputHelper
  include InputHelper
end

RSpec.describe TestInputHelper do
  subject { described_class.new }

  describe '.validate_integer?' do
    it 'returns true for valid integer within range' do
      expect(subject.validate_integer?('5', 1, 10)).to be true
    end

    it 'returns false for valid integer outside range' do
      expect(subject.validate_integer?('11', 1, 10)).to be false
    end

    it 'returns false for integer less than min_value' do
      expect(subject.validate_integer?('0', 1)).to be false
    end

    it 'returns false for non-integer string' do
      expect(subject.validate_integer?('abc', 1)).to be false
    end

    it 'returns false for negative integers when min_value is 0' do
      expect(subject.validate_integer?('-5', 0)).to be false
    end

    it 'returns true for valid integer when max_value is nil' do
      expect(subject.validate_integer?('5', 1)).to be true
    end

    it 'returns false for empty string' do
      expect(subject.validate_integer?('', 1)).to be false
    end
  end

  describe '.get_valid_integer_input' do
    describe '#get_valid_input' do
      it 'prompts the user for input and returns a valid integer' do
        allow(subject).to receive(:gets).and_return("5\n")
        expect(subject.get_valid_integer_input('Enter a number', min_value: 1)).to eq(5)
      end
    end
  end
end
