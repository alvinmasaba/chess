# frozen_string_literal: true

require_relative 'game_board'
require_relative 'game_piece'
require_relative 'player'
require_relative 'chess_helpers'

# Plays a complete game of chess
class Game
  include Helpers

  attr_accessor :player1, :player2, :board, :finished, :draw, :turn

  def initialize
    @board = GameBoard.new
    @player1 = Player.new('Player 1', :white)
    @player2 = Player.new('Player 2', :black)
    @turn = player1
    @finished = false
    @draw = false
  end

  def play
    # intro
    @player1.choose_name
    @player2.choose_name
    @board.display_board

    until @finished
      puts "\n#{@turn}, it's your turn."
    end
  end
end
