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

  def move(opponent)
    @in_check = check(opponent)
    
    # Checks for checkmate if in check.
    if @in_check
      puts "\nCheckmate." if checkmate(opponent) 

    puts "\nCheck." if @in_check
    
    puts "\n#{@name}, it's your move."

    destination = @in_check ? until_not_in_check(opponent) : return_valid_dest
    move_piece(destination)
  end

  def checkmate(opponent, pos = 'A1')
    # Make each valid move in the game and check if player is still in check.
    @pieces.each do |piece|
      og_position = piece.position

      until pos == 'H8'
        # If pos is a valid destination, move the piece there and run check
        if valid_dest?(pos, @board, piece)
          piece.position = pos

          # Return false if check returns false
          return false unless check(opponent)
        end

        piece.position = og_position

        if pos[1] == '8'
          "#{increment(pos[0])}#{increment(pos[1])}"
        else
          "#{pos[0]}#{increment(pos[1])}"
        end
      end
    end

    true
  end

  def check(opponent, check = false)
    # Iterates through opponent's pieces.
    opponent.pieces.each do |piece|
      king = @pieces.select { |plyr_piece| plyr_piece.name == 'King' }
                    .fetch(0)

      # Returns true if the king's position is a valid destination.
      next unless valid_dest?(king.position, @board, piece)

      check = true
    end

    check
  end

  private

  def move_piece(destination)
    # Takes the piece if there is an opponent piece present at destination.
    take_piece(find_piece(destination, @board.board))

    @selected_piece.change_position(destination)

    # Sets selected piece's first move to false if it was its first move.
    @selected_piece.first_move = false if @selected_piece.first_move
  end

  def collect_pieces(pieces = [])
    @board.board.each do |row|
      row.each do |piece|
        pieces << piece unless opp_piece?(piece) || piece == EMPTY_SQUARE
      end
    end

    pieces
  end

  def return_valid_dest
    select_piece
    destination = enter_destination
    until_valid_dest(destination)
  end

  def until_not_in_check(opponent)
    while @in_check
      select_piece
      old_position = @selected_piece.position
      destination = enter_destination
      destination = until_valid_dest(destination)

      # Change the piece's position and then check if the king is still in check.
      @selected_piece.change_position(destination)
      check(opponent)

      # Revert the piece's position if still in check.
      @selected_piece.change_position(old_position)
    end

    destination
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

  def until_valid_dest(destination)
    until valid_dest?(destination, @board, @selected_piece)
      puts "\nInvalid move. Re-enter the coordinates you wish to move to or enter 1 to select a different piece:\n"

      input = gets.chomp.downcase
      destination = reenter_destination(input)
    end

    destination
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
      piece = opp_piece?(piece) ? select_piece : piece
    else
      puts "\nYou can only select one of your OWN pieces."
      piece = select_piece
    end

    @selected_piece = piece
  end

  def opp_piece?(piece)
    piece.is_a?(GamePiece) && (piece.color != @color)
  end
end
