# frozen_string_literal: true

# Creates an active chess player
class Player
  attr_accessor :name, :color, :in_check, :in_checkmate

  def initialize(name, color)
    @in_check = false
    @in_checkmate = false
    @name = name
    @color = color
  end
end
