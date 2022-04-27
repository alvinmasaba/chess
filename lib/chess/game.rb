# frozen_string_literal: true

require_relative 'game_board'
require_relative 'game_piece'
require_relative 'player'
require_relative 'chess_helpers'

# Plays a complete game of chess
class Game
  include Helpers

  attr_accessor :player1, :player2, :board, :finished, :turn

  def initialize
    @board = GameBoard.new
    @player1 = Player.new('Player 1', :white, @board)
    @player2 = Player.new('Player 2', :black, @board)
    @turn = @player1
    @finished = false
  end

  def play
    # intro
    @player1.choose_name
    @player2.choose_name
    @board.display_board

    until @finished
      puts "\nCheck." if @turn.in_check
      puts "\n#{@turn.name}, it's your turn."
      @turn.move
      @board.display_board
      change_turn
    end
  end

  def check
    # Iterates through opponent's pieces.
    opp = @turn == @player1 ? @player2 : @player1

    opp.pieces.each do |piece|
      king = @turn.pieces.select { |plyr_piece| plyr_piece.name == 'King' }
                  .fetch(0)

      # Returns true if the king's position is a valid destination.
      next unless valid_dest?(king.position, @board, piece)

      @turn.in_check = true
    end
  end

  private

  def change_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end
end
