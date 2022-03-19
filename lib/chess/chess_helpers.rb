# frozen_string_literal: true

# Chess helper functions
module Helpers
  # Letters to integer conversion hash for chess game board.
  ALPHA_TO_NUM = { 'a': 1, 'b': 2, 'c': 3, 'd': 4,
                   'e': 5, 'f': 6, 'g': 7, 'h': 8 }.freeze

  def convert_to_num(string)
    ALPHA_TO_NUM[string.downcase.to_sym]
  end

  def change_in_coordinates(pos, dest)
    # Convert pos and dest to wholy numeric coordinates.
    x1 = convert_to_num(pos[0])
    y1 = pos[1].to_i
    x2 = convert_to_num(dest[0])
    y2 = dest[1].to_i

    # Return the change in x and the change in y.
    [(x1 - x2).abs, (y1 - y2).abs]
  end

  def convert_to_coordinates(pos)
    x = pos[1].to_i - 1
    y = convert_to_num(pos[0] - 1)

    [x, y]
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

  def find_piece(position, board)
    # If the string entered is in the format '[letter][integer]', convert
    # to corresponding index in gameboard array. E.g. 'A1' == [0][0].
    piece = [convert_to_num(position[0]) - 1, position[1].to_i - 1]
    board[piece[0]][piece[1]]
  end

  def valid_pos?(pos)
    # A valid position is a string of length 2.
    return false unless pos.size == 2

    # It starts with a letter between A and H and ends
    # with an integer between 1 and 8 and cannot be its
    # own position.
    /[A-Ha-h][1-8]/.match?(pos)
  end

  def color_match?(color1, color2)
    color1 == color2
  end
end
