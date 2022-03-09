# frozen_string_literal: true

# Creates a playable chess board
class GameBoard
  attr_accessor :board

  def initialize
    # Unicode space will occupy the same space as a chess piece, maintaining
    # the size of the board when drawn.
    @board = Array.new(8) { Array.new(8, "\u0020") }
  end

  def display_board
    separator = Array.new(8 + 1, '+').join('---')

    board.each do |row|
      puts separator

      row.each { |i| print "| #{row[i]} " }

      print '|'
      print "\n"
    end

    puts separator
  end
end
