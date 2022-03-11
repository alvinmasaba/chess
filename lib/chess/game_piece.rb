# frozen_string_literal: true

require_relative 'chess_helpers'

# Creates a movable chess piece
class GamePiece
  include Helpers

  attr_accessor :position, :color

  def initialize(position, color = 'white')
    @position = position
    @color = color
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
  attr_accessor :symbol, :first_move

  def initialize(position, color = 'white', symbol = ["\u2656", "\u265C"])
    super
    @symbol = symbol
    @first_move = true
  end

  def valid_pos?(pos)
    # For a rook, a valid position shares either the same letter or number index
    # as the original position. E.g. 'A1' to 'A9' or 'A3' to 'D3'.
    return false unless super

    position[0].match?(pos[0]) || position[1].match?(pos[1])
  end
end

# Creates a game piece which moves like a Bishop
class Bishop < GamePiece
  attr_accessor :symbol

  def initialize(position, color = 'white', symbol = ["\u2657", "\u265D"])
    super
    @symbol = symbol
  end

  def valid_pos?(pos)
    return false unless super

    # A valid position is the same absolute distance removed from the origin on
    # both the x and y axis. E.g. [2,-2], [-5,5], [-1,-1], [3,3].
    coord = convert_to_coordinates(position, pos)
    coord[0] == coord[1]
  end
end

# Creates a game piece which moves like a Knight
class Knight < GamePiece
  attr_accessor :symbol

  def initialize(position, color = 'white', symbol = ["\u2658", "\u265E"])
    super
    @symbol = symbol
  end

  def valid_pos?(pos)
    return false unless super

    # A valid position has an absolute distance removed of either [1, 2]
    # or [2, 1] in terms of x and y.
    coord = convert_to_coordinates(position, pos)
    coord.include?(1) && coord.include?(2)
  end
end

# Creates a game piece which moves like a Knight
class Queen < GamePiece
  attr_accessor :symbol

  def initialize(position, color = 'white', symbol = ["\u2655", "\u265B"])
    super
    @symbol = symbol
  end

  def valid_pos?(pos)
    return false unless super

    coord = convert_to_coordinates(position, pos)

    # Queen movement is a combination of Rook and Bishop movement
    if position[0].match?(pos[0]) || position[1].match?(pos[1])
      true
    else
      coord[0] == coord[1]
    end
  end
end

# Creates a game piece which moves like a King
class King < GamePiece
  attr_accessor :symbol, :first_move

  def initialize(position, color = 'white', symbol = ["\u2654", "\u265A"])
    super
    @symbol = symbol
    @first_move = true
  end

  def valid_pos?(pos)
    return false unless super

    # A King can move at most 1 space in any direction.
    coord = convert_to_coordinates(position, pos)
    coord.all? { |val| val.between?(0, 1) }
  end
end

# Creates a game piece which moves like a King
class Pawn < GamePiece
  attr_accessor :symbol, :first_move

  def initialize(position, color = 'white', symbol = ["\u2659", "\u265F"])
    super
    @symbol = symbol
    @first_move = true
  end

  def move(dest)
    if valid_pos?(dest)
      @position = dest
      @first_move = false
    else
      puts 'Invalid move.'
    end
  end

  def valid_pos?(pos)
    coord = convert_to_coordinates(position, pos)

    if first_move
      [[0, 1], [0, 2]].include?(coord)
    else
      coord == [0, 1]
    end
  end
end
