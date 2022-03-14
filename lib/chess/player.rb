# frozen_string_literal: true

require_relative 'chess_helpers'
# Creates an active chess player
class Player
  attr_accessor :name, :color, :in_check, :in_checkmate

  def initialize(name, color)
    @in_check = false
    @in_checkmate = false
    @name = name
    @color = color
  end

  def choose_name
    @name = enter_name(@name)
  end
end
