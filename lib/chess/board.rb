# frozen_string_literal: true

# Creates a playable chess board
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) {''} }
  end

  def display_board(board)
    separator = Array.new(8 + 1, '+').join('---')

    board.each do |row|
      i = 0

      puts separator

      while i < 8
        print "| #{row[i]}  "
        i += 1
      end

      print '|'
      print "\n"
    end

    puts separator
  end
end
