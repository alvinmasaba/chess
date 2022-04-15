# frozen_string_literal: true

require_relative 'chess_helpers'
# Creates an active chess player
class Player
  include Helpers

  attr_accessor :name, :color, :board, :selected_piece, :pieces,
                :taken_pieces, :in_check, :in_checkmate

  def initialize(name, color, board)
    @in_check = false
    @in_checkmate = false
    @name = name
    @color = color
    @board = board
    @selected_piece = nil
    @pieces = collect_pieces
    @taken_pieces = []
  end

  def choose_name
    @name = enter_name(@name)
    puts "\n#{@name}, you control the #{@color} pieces."
  end

  def move
    select_piece

    destination = enter_destination

    until valid_dest?(destination)
      puts "\nInvalid move. Re-enter the coordinates you wish to move to or enter 1 to select a different piece:\n"

      input = gets.chomp.downcase
      destination = reenter_destination(input)
    end

    # Takes the piece if there is an opponent piece present at destination.
    take_piece(find_piece(destination, @board.board))

    @selected_piece.change_position(destination)

    # Sets selected piece's first move to false if it was its first move.
    @selected_piece.first_move = false if @selected_piece.first_move
  end

  private

  def collect_pieces(pieces = [])
    @board.board.each do |row|
      row.each do |piece|
        pieces << piece unless opp_piece?(piece) || piece == EMPTY_SQUARE
      end
    end

    pieces
  end

  def enter_destination
    puts "\nEnter the coordinates of the square you want to move to:\n"
    destination = gets.chomp.downcase

    destination
  end

  def reenter_destination(input)
    if input == '1'
      select_piece
      destination = enter_destination
    else
      destination = input
    end

    destination
  end

  def valid_dest?(dest)
    return false unless @selected_piece.valid_pos?(dest) &&
                        dest != @selected_piece.position

    # Return false unless destination is empty or contains an opp piece.
    val = find_piece(dest, @board.board)
    return false unless val == "\u0020" || val.color != @color

    return true if @selected_piece.can_jump

    path = find_path(@selected_piece.position, dest)

    obstructed?(path, @board.board, @selected_piece) ? false : true
  end

  def take_piece(piece)
    # Piece will only be an opponent piece or an empty square.
    # Calls take if it is an GamePiece.
    take(piece) if piece.is_a?(GamePiece)
  end

  def take(piece)
    # Appends opponent piece to taken_pieces array, then sets position
    # of piece to nil to remove it from the board.
    @taken_pieces << piece
    piece.position = nil
  end

  def select_piece
    puts "\nEnter the coordinates of the piece you would like to move:\n"
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
