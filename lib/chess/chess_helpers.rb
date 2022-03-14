# frozen_string_literal: true

# Chess helper functions
module Helpers
  # Letters to integer conversion hash for chess game board.
  ALPHA_TO_NUM = { 'a': 1, 'b': 2, 'c': 3, 'd': 4,
                   'e': 5, 'f': 6, 'g': 7, 'h': 8 }.freeze

  def convert_to_num(string)
    ALPHA_TO_NUM[string.downcase.to_sym]
  end

  def convert_to_coordinates(pos, dest)
    # Convert pos and dest to wholy numeric coordinates.
    x1 = convert_to_num(pos[0])
    y1 = pos[1].to_i
    x2 = convert_to_num(dest[0])
    y2 = dest[1].to_i

    [(x1 - x2).abs, (y1 - y2).abs]
  end

  def enter_name(name)
    puts "\n#{name} please enter a name. Your name may be up to 10 chars max.\n\n"
    new_name = gets.chomp

    if /\S/.match(new_name) && new_name.size.between?(1, 10)
      new_name
    else
      enter_name
    end
  end
end
