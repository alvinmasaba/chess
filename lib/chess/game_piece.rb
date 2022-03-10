# frozen_string_literal: true

# Creates a movable chess piece
class GamePiece
  attr_accessor :color, :player, :transformations

  def initialize(color, player)
    @color = color
    @player = player
  end
end
  