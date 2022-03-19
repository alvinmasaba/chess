# frozen_string_literal: true

require_relative 'chess_helpers'
# Creates an active chess player
class Player
  include Helpers

  attr_accessor :name, :color, :in_check, :in_checkmate, :selected_piece

  def initialize(name, color)
    @in_check = false
    @in_checkmate = false
    @name = name
    @color = color
    @selected_piece = nil
  end

  def choose_name
    @name = enter_name(@name)
  end

  def select_piece(board)
    puts "\nYou can only select one of your own pieces."

    pos = gets.chomp

    until valid_pos?(pos) && color_match?(find_piece(pos, board).color, @color)
      pos = gets.chomp
    end

    # If the color of the piece at the converted position matches the
    # color of the player whose turn it is, select the piece, or
    # puts an error message and call the function again.
    @selected_piece = find_piece(pos, board)
  end

  def move_piece(board)
    select_piece(board)
    @selected_piece.move
  end
end
