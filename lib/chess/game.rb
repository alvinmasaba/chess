# frozen_string_literal: true

require_relative 'game_board'
require_relative 'game_piece'
require_relative 'player'
require_relative 'chess_helpers'

# Plays a complete game of chess
class Game
  include Helpers

  attr_accessor :player1, :player2, :board, :finished, :turn, :selected_piece

  def initialize
    @board = GameBoard.new.board
    @player1 = Player.new('Player 1', :white)
    @player2 = Player.new('Player 2', :black)
    @turn = @player1
    @finished = false
    @selected_piece = nil
  end

  def play
    # intro
    @player1.choose_name
    @player2.choose_name
    @board.display_board

    until @finished
      puts "\n#{@turn}, it's your turn."
      @turn.move
    end
  end

  def select_piece
    puts "\nYou can only select one of your own pieces."
    piece = gets.chomp

    until valid_pos?(piece) && color_match?(find_piece(piece, @board), @turn)
      piece = gets.chomp
    end

    # If the color of the piece at the converted position matches the
    # color of the player whose turn it is, select the piece, or
    # puts an error message and call the function again.
    @selected_piece = find_piece(piece, @board)
  end

  private

  def color_match?(piece1, piece2)
    piece1.color == piece2.color
  end
end
