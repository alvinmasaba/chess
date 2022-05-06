# frozen_string_literal: true

require_relative 'piece_movement'

# Chess helper functions
module Helpers
  include PieceMovement

  # Letters to integer conversion hash for chess game board.
  ALPHA_TO_NUM = { 'a': 1, 'b': 2, 'c': 3, 'd': 4,
                   'e': 5, 'f': 6, 'g': 7, 'h': 8 }.freeze

  EMPTY_SQUARE = "\u0020"

  def convert_to_num(string)
    ALPHA_TO_NUM[string.downcase.to_sym]
  end

  def convert_to_coordinates(pos)
    # Converts alphanumeric coordinates to a nested
    # array coordinates.
    return nil if pos.size != 2

    x = pos[1].to_i - 1
    y = convert_to_num(pos[0]) - 1

    [x, y]
  end

  def change_in_coordinates(pos, dest)
    return nil if invalid_sizes(pos, dest)

    # Convert pos and dest to wholy numeric coordinates.
    x1 = convert_to_num(pos[0])
    y1 = pos[1].to_i
    x2 = convert_to_num(dest[0])
    y2 = dest[1].to_i

    # Return the change in x and the change in y.
    [(x2 - x1), (y2 - y1)]
  end

  def invalid_sizes(pos, dest)
    # Returns false unless both pos and dest are of length 2.
    pos.size != 2 || dest.size != 2
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

  def valid_pos?(pos)
    # A valid position is a string of length 2.
    return false if pos.size != 2 || pos.nil?

    # It starts with a letter between A and H and ends
    # with an integer between 1 and 8 and cannot be its
    # own position.
    /[A-Ha-h][1-8]/.match?(pos)
  end

  def find_piece(position, board, val = EMPTY_SQUARE)
    # Returns the value at the given position.
    board.each do |row|
      row.each do |piece|
        next unless piece.is_a?(GamePiece) && !piece.position.nil?

        val = piece if piece.position.downcase == position.downcase
      end
    end

    val
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

  def obstructed?(path, board, piece, obstructed = false)
    # Returns true if there are occupied squares within the path.
    # Otherwise returns false.
    return false if piece.can_jump

    path.each do |sqr|
      val = find_piece(sqr, board)

      next if val == EMPTY_SQUARE

      obstructed = true
    end

    obstructed
  end

  def king_in_check?(player, opponent, board, check = false)
    king = player.pieces.select { |plyr_piece| plyr_piece.name == 'King' }
                 .fetch(0)

    # Iterates through opponent's pieces.
    opponent.pieces.each do |piece|
      next if piece.position.nil?

      # Returns true if the king's position is a valid destination.
      next unless valid_dest?(king.position, board, piece)

      check = true
    end

    check
  end
end
