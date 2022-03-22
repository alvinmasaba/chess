# frozen_string_literal: true

require_relative 'game_piece'
require 'pry-byebug'

# Creates a playable chess board
class GameBoard
  include Helpers

  attr_accessor :board

  BLACK = [Rook.new(self, 'A1', :black), Knight.new(self, 'B1', :black),
           Bishop.new(self, 'C1', :black), Queen.new(self, 'D1', :black),
           King.new(self, 'E1', :black), Bishop.new(self, 'F1', :black),
           Knight.new(self, 'G1', :black), Rook.new(self, 'H1', :black)].freeze

  WHITE = [Rook.new(self, 'A8', :white), Knight.new(self, 'B8', :white),
           Bishop.new(self, 'C8', :white), Queen.new(self, 'D8', :white),
           King.new(self, 'E8', :white), Bishop.new(self, 'F8', :white),
           Knight.new(self, 'G8', :white), Rook.new(self, 'H8', :white)].freeze

  BLACK_PAWN = [Pawn.new(self, 'A2', :black), Pawn.new(self, 'B2', :black),
                Pawn.new(self, 'C2', :black), Pawn.new(self, 'D2', :black),
                Pawn.new(self, 'E2', :black), Pawn.new(self, 'F2', :black),
                Pawn.new(self, 'G2', :black), Pawn.new(self, 'H2', :black)].freeze

  WHITE_PAWN = [Pawn.new(self, 'A7', :white), Pawn.new(self, 'B7', :white),
                Pawn.new(self, 'C7', :white), Pawn.new(self, 'D7', :white),
                Pawn.new(self, 'E7', :white), Pawn.new(self, 'F7', :white),
                Pawn.new(self, 'G7', :white), Pawn.new(self, 'H7', :white)].freeze

  def initialize
    @board = create_board
  end

  def display_board(idx = 1)
    # Update the board array then print the board display
    update_board
    separator = '     ' + Array.new(8 + 1, '+').join('---')
    create_header

    board.each do |row|
      puts separator
      print "  #{idx}  "

      row.each_with_index do |piece, i|
        piece = piece == "\u0020" ? row[i] : piece.symbol
        print "| #{piece} "
      end

      print '|'
      print "\n"
      idx += 1
    end

    puts separator
  end

  private

  def create_header
    letters = ('A'..'H').to_a
    puts "\n"
    print '      '
    letters.each { |letter| print " #{letter}  " }
    puts "\n"
  end

  def create_board
    # Unicode space will occupy the same space as a chess piece, maintaining
    # the size of the board when drawn.
    temp_board = Array.new(8) { Array.new(8, "\u0020") }
    new_board = []

    temp_board.each_with_index do |_, i|
      new_board << BLACK if i.zero?
      new_board << BLACK_PAWN if i == 1
      new_board << WHITE_PAWN if i == 6
      new_board << WHITE if i == 7
      new_board << Array.new(8, "\u0020") if i.between?(2, 5)
    end

    new_board
  end

  def update_board
    temp_board = Array.new(8) { Array.new(8, "\u0020") }

    @board.each do |row|
      row.each do |val|
        # If val is a GamePiece, find its equivalent nested array location based
        # on its position value, and insert into temp board at that index.
        if val.is_a?(GamePiece)
          coord = convert_to_coordinates(val.position)
          temp_board[coord[0]][coord[1]] = val
        end
      end
    end

    # Replace @board with the updated array.
    @board = temp_board
  end
end
