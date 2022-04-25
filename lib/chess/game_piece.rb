# frozen_string_literal: true

require_relative 'chess_helpers'

# Creates a movable chess piece
class GamePiece
  include Helpers

  attr_accessor :position, :color, :symbol, :first_move, :name, :can_jump

  def initialize(position = nil, color = :white, name = 'name',
                 symbol = { 'white': "\u2659", 'black': "\u265F" })
    @position = position
    @color = color
    @symbol = symbol[color]
    @first_move = true
    @name = name
    @can_jump = false
  end

  def valid_pos?(pos)
    return false unless super

    # Returns false if the entered position is the piece's own position.
    pos != @position
  end

  def change_position(new_position)
    @position = new_position
  end
end

# Creates a game piece which moves like a Rook
class Rook < GamePiece
  def initialize(position = nil, color = :white, name = 'Rook',
                 symbol = { 'white': "\u265C", 'black': "\u2656" })
    super
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
  def initialize(position = nil, color = :white, name = 'Bishop',
                 symbol = { 'white': "\u265D", 'black': "\u2657" })
    super
  end

  def valid_pos?(pos)
    return false unless super

    # A valid position is the same absolute distance removed from the origin on
    # both the x and y axis. E.g. [2,-2], [-5,5], [-1,-1], [3,3].
    change = change_in_coordinates(position, pos)
    change[0] == change[1]
  end
end

# Creates a game piece which moves like a Knight
class Knight < GamePiece
  def initialize(position = nil, color = :white, name = 'Knight',
                 symbol = { 'white': "\u265E", 'black': "\u2658" })
    super
    @can_jump = true
  end

  def valid_pos?(pos)
    return false unless super

    # A valid position has an absolute distance removed of either [1, 2]
    # or [2, 1] in terms of x and y.
    change = change_in_coordinates(position, pos)
    change.include?(1) && change.include?(2)
  end
end

# Creates a game piece which moves like a Knight
class Queen < GamePiece
  def initialize(position = nil, color = :white, name = 'Queen',
                 symbol = { 'white': "\u265B", 'black': "\u2655" })
    super
  end

  def valid_pos?(pos)
    return false unless super

    change = change_in_coordinates(position, pos)

    # Queen movement is a combination of Rook and Bishop movement
    if position[0].match?(pos[0]) || position[1].match?(pos[1])
      true
    else
      change[0] == change[1]
    end
  end
end

# Creates a game piece which moves like a King
class King < GamePiece
  def initialize(position = nil, color = :white, name = 'King',
                 symbol = { 'white': "\u265A", 'black': "\u2654" })
    super
  end

  def valid_pos?(pos)
    return false unless super

    # A King can move at most 1 space in any direction.
    change = change_in_coordinates(position, pos)
    change.all? { |val| val.between?(0, 1) }
  end
end

# Creates a game piece which moves like a King
class Pawn < GamePiece
  def initialize(position = nil, color = :white, name = 'Pawn',
                 symbol = { 'white': "\u265F", 'black': "\u2659" })
    super
  end

  def valid_pos?(pos)
    return false unless super

    change = change_in_coordinates(position, pos)

    if first_move
      [[0, 1], [0, 2]].include?(change)
    else
      change == [0, 1]
    end
  end
end
