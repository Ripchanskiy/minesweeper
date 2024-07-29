# frozen_string_literal: true

module OutputHelper
  def print_message(message)
    puts message
  end

  def print_grid(grid)
    grid.each do |row|
      row.each do |cell|
        if cell[:revealed]
          if cell[:has_hole]
            print 'H '
          else
            print "#{cell[:touching_holes]} "
          end
        else
          print '. '
        end
      end
      puts
    end
  end
end
