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

  def move(board)
    puts "\nEnter the coordinates of the piece you would like to move."
    select_piece(board)
    @selected_piece.move_piece
  end

  private

  def select_piece(board)
    pos = gets.chomp
    piece = find_piece(pos, board)

    if valid_pos?(pos) && piece != "\u0020" && color_match?(piece.color, @color)
      @selected_piece = piece
    else
      puts "\nYou can only select one of your OWN pieces."
      @selected_piece = select_piece(board)
    end
  end
end
