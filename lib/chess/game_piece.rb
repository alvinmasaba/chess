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

  def convert_to_num(string)
    ALPHA_TO_NUM[string.downcase.to_sym]
  end

  def convert_to_coordinates(pos)
    # Convert @position and pos to wholy numeric coordinates.
    x1 = convert_to_num(position[0])
    y1 = position[1].to_i
    x2 = convert_to_num(pos[0])
    y2 = pos[1].to_i

    [x1, x2, y1, y2]
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
  def valid_pos?(pos)
    return false unless super

    coord = convert_to_coordinates(pos)

    # A valid position is the same absolute distance removed from the origin on
    # both the x and y axis. E.g. [2,-2], [-5,5], [-1,-1], [3,3].
    (coord[0] - coord[1]).abs == (coord[2] - coord[3]).abs
  end
end

# Creates a game piece which moves like a Knight
class Knight < GamePiece
  def valid_pos?(pos)
    return false unless super

    coord = convert_to_coordinates(pos)

    # A valid position has an absolute distance removed of either [1, 2]
    # or [2, 1] in terms of x and y.
    result = [(coord[0] - coord[1]).abs, (coord[2] - coord[3]).abs]
    result.include?(1) && result.include?(2)
  end
end

# Creates a game piece which moves like a Knight
class Queen < GamePiece
  def valid_pos?(pos)
    return false unless super

    coord = convert_to_coordinates(pos)

    # Queen movement is a combination of Rook and Bishop movement
    if position[0].match?(pos[0]) || position[1].match?(pos[1])
      true
    else
      (coord[0] - coord[1]).abs == (coord[2] - coord[3]).abs
    end
  end
end
