# frozen_string_literal: true

require_relative 'chess_helpers'
# Creates an active chess player
class Player
  include Helpers

  attr_accessor :name, :color, :in_check, :in_checkmate, :selected_piece, :board

  def initialize(name, color, board)
    @in_check = false
    @in_checkmate = false
    @name = name
    @color = color
    @board = board
    @selected_piece = nil
  end

  def choose_name
    @name = enter_name(@name)
  end

  def move
    puts "\nEnter the coordinates of the piece you would like to move."
    select_piece
    @selected_piece.move_piece(@board.board, self)
  end

  private

  def select_piece
    pos = gets.chomp

    if valid_pos?(pos)
      piece = find_piece(pos, @board.board)
      # If the entered position contains a GamePiece with the same color as the
      # player selecting it, sets @selected_piece to that piece. Else, calls
      # select_piece recursively.
      piece = piece.is_a?(GamePiece) && color_match?(piece.color, @color) ? piece : select_piece
    else
      puts "\nYou can only select one of your OWN pieces."
      piece = select_piece
    end

    @selected_piece = piece
  end
end
