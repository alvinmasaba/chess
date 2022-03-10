# frozen_string_literal: true

# Creates a movable chess piece
class GamePiece
  attr_accessor :position

  ALPHA_TO_NUM = { 'a': 1, 'b': 2, 'c': 3, 'd': 4,
                   'e': 5, 'f': 6, 'g': 7, 'h': 8 }.freeze

  def initialize(position)
    @position = position
  end

  def move(dest)
    if valid_pos?(dest)
      @position = dest
    else
      puts 'Invalid move.'
    end
  end

  private

  def valid_pos?(pos)
    # A valid position is a string of length 2.
    return false unless pos.size == 2

    # It starts with a letter between A and H and ends
    # with an integer between 1 and 8 and cannot be its
    # own position.
    /[A-Ha-h][1-8]/.match?(pos) && pos != position
  end
end

# Creates a game piece which moves like a Rook
class Rook < GamePiece
  def valid_pos?(pos)
    # For a rook, a valid position shares either the same letter or number index
    # as the original position. E.g. 'A1' to 'A9' or 'A3' to 'D3'.
    return false unless super

    position[0].match?(pos[0]) || position[1].match?(pos[1])
  end
end

# Creates a game piece which moves like a Bishop
class Bishop < GamePiece
end
