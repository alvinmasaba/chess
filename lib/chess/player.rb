# frozen_string_literal: true

# Creates an active chess player
class Player
  attr_accessor :name, :in_check, :in_checkmate

  def initialize(name)
    @in_check = false
    @in_checkmate = false
    @name = name
  end
end
