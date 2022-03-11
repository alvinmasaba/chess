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
end
