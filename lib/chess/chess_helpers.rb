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
    return nil if pos.size != 2 || dest.size != 2

    # Convert pos and dest to wholy numeric coordinates.
    x1 = convert_to_num(pos[0])
    y1 = pos[1].to_i
    x2 = convert_to_num(dest[0])
    y2 = dest[1].to_i

    # Return the change in x and the change in y.
    [(x1 - x2).abs, (y1 - y2).abs]
  end

  def convert_to_coordinates(pos)
    return nil if pos.size != 2

    x = pos[1].to_i - 1
    y = convert_to_num(pos[0]) - 1

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
    coord = convert_to_coordinates(position)
    board[coord[0]][coord[1]]
  end

  def valid_pos?(pos)
    # A valid position is a string of length 2.
    return false if pos.size != 2 || pos.nil?

    # It starts with a letter between A and H and ends
    # with an integer between 1 and 8 and cannot be its
    # own position.
    /[A-Ha-h][1-8]/.match?(pos)
  end

  def color_match?(color1, color2)
    color1 == color2
  end

  def step(c, delta = 1)
    [c.ord + delta].pack 'U'
  end

  def increment(c)
    step c, 1
  end

  def decrement(c)
    step c, -1
  end

  def find_diagonal_path(curr, dest)
    # Returns the descending or ascending diagonal path.
    return desc_diag(curr, dest) if dest[1] > curr[1]

    asc_diag(curr, dest)
  end

  def desc_diag(curr, dest, path = [])
    if dest[0] > curr[0]
      until curr == dest
        # Increments both letter and num coordinate to simulate
        # downward diagonal movement to the right.
        curr = "#{increment(curr[0])}#{increment(curr[1])}"
        path << curr unless curr == dest
      end
    else
      until curr == dest
        # Decrements letter and increments num coordinate to simulate
        # downward diagonal movement to the left.
        curr = "#{decrement(curr[0])}#{increment(curr[1])}"
        path << curr unless curr == dest
      end
    end

    path
  end

  def asc_diag(curr, dest, path = [])
    if dest[0] > curr[0]
      until curr == dest
        # Increments letter and decrements num coordinate to simulate
        # upward diagonal movement to the right.
        curr = "#{increment(curr[0])}#{decrement(curr[1])}"
        path << curr unless curr == dest
      end
    else
      until curr == dest
        # Decrements both letter and num coordinate to simulate
        # upward diagonal movement to the left.
        curr = "#{decrement(curr[0])}#{decrement(curr[1])}"
        path << curr unless curr == dest
      end
    end

    path
  end

  def find_vert_path(curr, dest)
    # Returns the descending or ascending vertical path.
    return desc_vert(curr, dest) if dest[1] > curr[1]

    asc_vert(curr, dest)
  end

  def desc_vert(curr, dest, path = [])
    until curr == dest
      # Increments num coordinate to simulate downward vertical movement.
      curr = "#{curr[0]}#{increment(curr[1])}"
      path << curr unless curr == dest
    end

    path
  end

  def asc_vert(curr, dest, path = [])
    until curr == dest
      curr = "#{curr[0]}#{decrement(curr[1])}"
      path << curr unless curr == dest
    end

    path
  end

  def find_horiz_path(curr, dest)
    # Returns the left or right horizontal path.
    return left_horiz(curr, dest) if dest[0] > curr[0]

    right_horiz(curr, dest)
  end

  def left_horiz(curr, dest, path = [])
    until curr == dest
      curr = "#{decrement(curr[0])}#{curr[1]}"
      path << curr unless curr == dest
    end

    path
  end

  def right_horiz(curr, dest, path = [])
    until curr == dest
      curr = "#{increment(curr[0])}#{curr[1]}"
      path << curr unless curr == dest
    end

    path
  end
end
