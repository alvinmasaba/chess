# frozen_string_literal: true

require_relative 'chess_helpers'

# Creates a movable chess piece
class GamePiece
  include Helpers

  attr_accessor :position, :color, :symbol, :first_move, :name

  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2659", 'black': "\u265F" }, name = 'name')
    @position = position
    @color = color
    @symbol = symbol[color]
    @first_move = true
    @name = name
  end

  def move_piece
    puts "\nEnter the coordinates of the square you want to move to."

    destination = gets.chomp

    if valid_pos?(destination)
      @position = destination
      @first_move = false
    else
      puts 'Invalid move.'
      move_piece
    end
  end

  private

  def valid_pos?(pos)
    super && pos != position
  end
end

# Creates a game piece which moves like a Rook
class Rook < GamePiece
  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2656", 'black': "\u265C" }, name = 'Rook')
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
  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2657", 'black': "\u265D" }, name = 'Bishop')
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
  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2658", 'black': "\u265E" }, name = 'Knight')
    super
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
  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2655", 'black': "\u265B" }, name = 'Queen')
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
  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2654", 'black': "\u265A" }, name = 'King')
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
  def initialize(position = nil, color = :white,
                 symbol = { 'white': "\u2659", 'black': "\u265F" }, name = 'Pawn')
    super
  end

  def valid_pos?(pos)
    change = change_in_coordinates(position, pos)

    if first_move
      [[0, 1], [0, 2]].include?(change)
    else
      change == [0, 1]
    end
  end
end
