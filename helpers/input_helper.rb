# frozen_string_literal: true

module InputHelper
  MIN_WIDTH = 5
  MIN_HEIGHT = 5
  MIN_HOLES_TO_GRID_GAP = 5

  def validate_integer?(value, min_value, max_value = nil)
    if value.match?(/^\d+$/)
      int_value = value.to_i
      int_value >= min_value && (max_value.nil? || int_value <= max_value)
    else
      false
    end
  end

  def get_valid_input(prompt, min_value: 0, max_value: nil)
    loop do
      print_message(prompt)
      input = gets.chomp
      return input.to_i if validate_integer?(input, min_value, max_value)

      range_message = max_value ? "and <= #{max_value}" : ""
      print_message("Value should be a valid integer >= #{min_value} #{range_message}")
    end
  end

  def print_message(message)
    puts message
  end
end
