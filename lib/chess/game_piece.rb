# frozen_string_literal: true

# Creates a movable chess piece
class GamePiece
  attr_accessor :color, :player, :transformations, :position

  def initialize(color, player, position)
    @color = color
    @player = player
    @position = position
  end

  def move(dest)
    return nil unless valid_pos?(dest)
  end

  private

  def valid_pos?(position)
    # A valid position is a string of length 2, starting with a letter between
    # A and H and ending with an integer between 1 and 8 (inclusive).
    return false unless position.size == 2

    /[A-Ha-h][1-8]/.match?(position)
  end
end
