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
    start_game

    until @finished
      opp = @turn == @player1 ? @player2 : @player1

      @turn.move(opp)
      @board.display_board
      change_turn
    end
  end

  private

  def change_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end

  def start_game
    # intro
    @player1.choose_name
    @player2.choose_name
    @board.display_board
  end
end
