# frozen_string_literal: true

require_relative 'game_piece'
require 'pry-byebug'

# Creates a playable chess board
class GameBoard
  include Helpers

  attr_accessor :board

  BLACK = [Rook.new('A1', :black), Knight.new('B1', :black),
           Bishop.new('C1', :black), Queen.new('D1', :black),
           King.new('E1', :black), Bishop.new('F1', :black),
           Knight.new('G1', :black), Rook.new('H1', :black)].freeze

  WHITE = [Rook.new('A8', :white), Knight.new('B8', :white),
           Bishop.new('C8', :white), Queen.new('D8', :white),
           King.new('E8', :white), Bishop.new('F8', :white),
           Knight.new('G8', :white), Rook.new('H8', :white)].freeze

  BLACK_PAWN = [Pawn.new('A2', :black), Pawn.new('B2', :black),
                Pawn.new('C2', :black), Pawn.new('D2', :black),
                Pawn.new('E2', :black), Pawn.new('F2', :black),
                Pawn.new('G2', :black), Pawn.new('H2', :black)].freeze

  WHITE_PAWN = [Pawn.new('A7', :white), Pawn.new('B7', :white),
                Pawn.new('C7', :white), Pawn.new('D7', :white),
                Pawn.new('E7', :white), Pawn.new('F7', :white),
                Pawn.new('G7', :white), Pawn.new('H7', :white)].freeze

  def initialize
    @board = create_board
  end

  def display_board(idx = 1)
    # Update the board array then print the board display
    update_board
    separator = '     ' + Array.new(8 + 1, '+').join('---')
    create_header

    @board.each do |row|
      puts separator
      print "  #{idx}  "

      build_rows(row)
      idx += 1
    end

    puts separator
  end

  private

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

  def build_rows(row)
    row.each_with_index do |piece, i|
      piece = piece == "\u0020" ? row[i] : piece.symbol
      print "| #{piece} "
    end

    print '|'
    print "\n"
  end

  def create_header
    letters = ('A'..'H').to_a
    puts "\n"
    print '      '
    letters.each { |letter| print " #{letter}  " }
    puts "\n"
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
