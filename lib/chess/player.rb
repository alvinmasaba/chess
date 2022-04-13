# frozen_string_literal: true

require_relative 'chess_helpers'
# Creates an active chess player
class Player
  include Helpers

  attr_accessor :name, :color, :board, :selected_piece,
                :taken_pieces, :in_check, :in_checkmate

  def initialize(name, color, board)
    @in_check = false
    @in_checkmate = false
    @name = name
    @color = color
    @board = board
    @selected_piece = nil
    @taken_pieces = []
  end

  def choose_name
    @name = enter_name(@name)
    puts "\n#{@name}, you control the #{@color} pieces."
  end

  def move
    puts "\nEnter the coordinates of the piece you would like to move.\n"
    select_piece
    @selected_piece.move_piece(@board.board, self)

    # Sets selected piece's first move to false if it was its first move.
    @selected_piece.first_move = false if @selected_piece.first_move
  end

  def take_piece(piece)
    take(piece)
  end

  private

  def take(piece)
    @taken_pieces << piece
    piece.position = nil
  end

  def select_piece
    pos = gets.chomp

    if valid_pos?(pos)
      piece = find_piece(pos, @board.board)
      # If the entered position contains a GamePiece with the same color as the
      # player selecting it, sets @selected_piece to that piece. Else, calls
      # select_piece recursively.
      piece = opp_piece?(piece) ? piece : select_piece
    else
      puts "\nYou can only select one of your OWN pieces."
      piece = select_piece
    end

    @selected_piece = piece
  end

  def opp_piece?(piece)
    piece.is_a?(GamePiece) && color_match?(piece.color, @color)
  end
end
