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
      puts "\n#{@turn.name}, it's your turn."
      @turn.move
      @board.display_board
      puts "\nCheck." if check
      change_turn
    end
  end

  def check
    # Iterates through player's pieces.
    @turn.pieces.each do |piece|
      opp = @turn == @player1 ? @player2 : @player1

      # Finds the position of the opponent's king.
      opp_king = opp.pieces.select { |opp_piece| opp_piece.name == 'King' }
                    .fetch(0)

      # Returns true if the king's position is a valid destination.
      next unless valid_dest?(opp_king.position, @board, piece)

      opp.in_check = true
      return true
    end

    false
  end

  private

  def change_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end
end
