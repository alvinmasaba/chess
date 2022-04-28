# frozen_string_literal: true

# Chess helper functions
module Helpers
  # Letters to integer conversion hash for chess game board.
  ALPHA_TO_NUM = { 'a': 1, 'b': 2, 'c': 3, 'd': 4,
                   'e': 5, 'f': 6, 'g': 7, 'h': 8 }.freeze

  EMPTY_SQUARE = "\u0020"

  def convert_to_num(string)
    ALPHA_TO_NUM[string.downcase.to_sym]
  end

  def change_in_coordinates(pos, dest)
    return nil if invalid_sizes(pos, dest)

    # Convert pos and dest to wholy numeric coordinates.
    x1 = convert_to_num(pos[0])
    y1 = pos[1].to_i
    x2 = convert_to_num(dest[0])
    y2 = dest[1].to_i

    # Return the change in x and the change in y.
    [(x1 - x2).abs, (y1 - y2).abs]
  end

  def invalid_sizes(pos, dest)
    # Returns false unless both pos and dest are of length 2.
    pos.size != 2 || dest.size != 2
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

  def valid_dest?(dest, board, selected_piece)
    return false unless selected_piece.valid_pos?(dest) &&
                        dest != selected_piece.position

    # Return false unless destination is empty or contains an opp piece.
    val = find_piece(dest, board.board)
    return false unless val == "\u0020" || val.color != selected_piece.color

    return true if selected_piece.can_jump

    path = find_path(selected_piece.position, dest)

    obstructed?(path, board.board, selected_piece) ? false : true
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

  def find_path(curr_pos, dest)
    curr_pos = curr_pos.downcase
    dest = dest.downcase

    # Finds the path to destination based on if it is located
    # diagonally, vertically or horizontally from the current position.
    if dest[0] != curr_pos[0] && dest[1] != curr_pos[1]
      find_diagonal_path(curr_pos, dest)
    elsif dest[0] == curr_pos[0]
      find_vert_path(curr_pos, dest)
    else
      find_horiz_path(curr_pos, dest)
    end
  end

  def get_path(curr, dest, col_step, row_step, path = [])
    # Appends 'col-row' to path array until destination value is reached.
    # Returns path array.
    until curr == dest
      col = choose_step(col_step, curr[0])
      row = choose_step(row_step, curr[1])

      curr = "#{col}#{row}"

      path << curr unless curr == dest
    end

    path
  end

  def choose_step(string, val)
    # Increments, decrements or simply returns value based on input string.
    if string == 'increment'
      increment(val)
    elsif string == ''
      val
    else
      decrement(val)
    end
  end

  def find_diagonal_path(curr, dest)
    # Returns the descending or ascending diagonal path.
    return desc_diag(curr, dest) if dest[1] > curr[1]

    asc_diag(curr, dest)
  end

  def desc_diag(curr, dest)
    return get_path(curr, dest, 'increment', 'increment') if dest[0] > curr[0]

    # Decrements letter and increments num coordinate to simulate
    # downward diagonal movement to the left.
    get_path(curr, dest, 'decrement', 'increment')
  end

  def asc_diag(curr, dest)
    # Increments letter and decrements num coordinate to simulate
    # upward diagonal movement to the right.
    return get_path(curr, dest, 'increment', 'decrement') if dest[0] > curr[0]

    # Decrements both letter and num coordinate to simulate
    # upward diagonal movement to the left.
    get_path(curr, dest, 'decrement', 'decrement')
  end

  def find_vert_path(curr, dest)
    # Returns the descending or ascending vertical path.
    return desc_vert(curr, dest) if dest[1] > curr[1]

    asc_vert(curr, dest)
  end

  def desc_vert(curr, dest)
    # Increments num coordinate to simulate downward vertical movement.
    get_path(curr, dest, '', 'increment')
  end

  def asc_vert(curr, dest)
    get_path(curr, dest, '', 'decrement')
  end

  def find_horiz_path(curr, dest)
    # Returns the left or right horizontal path.
    return right_horiz(curr, dest) if dest[0] > curr[0]

    left_horiz(curr, dest)
  end

  def left_horiz(curr, dest)
    get_path(curr, dest, 'decrement', '')
  end

  def right_horiz(curr, dest)
    get_path(curr, dest, 'increment', '')
  end

  def obstructed?(path, board, piece, obstructed = false)
    return false if piece.can_jump

    path.each do |sqr|
      val = find_piece(sqr, board)

      next if val == EMPTY_SQUARE

      obstructed = true
    end

    puts 'Invalid move.' if obstructed

    obstructed
  end
end
