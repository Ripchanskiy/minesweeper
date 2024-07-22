# frozen_string_literal: true

require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

SimpleCov.start do
  filters.clear

  add_filter %w[ /spec]

  add_group "Services", "services"
  add_group "Helpers", "helpers"

  at_exit do
    SimpleCov.result.format!
    $stdout.print("UNIT (#{SimpleCov.result.covered_percent.floor(2)}%) covered\n")
  end
end
