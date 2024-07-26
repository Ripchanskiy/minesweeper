# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe IterativeStrategy do
  let(:grid_service) { GridService.new(height, width, holes_count) }
  subject(:strategy) { described_class.new(grid_service) }

  it_behaves_like 'a strategy'
end
