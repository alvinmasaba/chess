# frozen_string_literal: true

require 'json'
require_relative 'game_serializer'
require_relative 'game_board'
require_relative 'game_piece'
require_relative 'player'
require_relative 'chess_helpers'

# Plays a complete game of chess
class Game
  include GameSerializer
  include Helpers

  attr_accessor :player1, :player2, :board, :turn, :finished

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
      play_turn
      @board.display_board
      change_turn
    end

    puts "\nCheckmate. #{@turn.name} is the winner."
  end

  def check(opponent)
    @turn.in_check = king_in_check?(@turn, opponent, @board)
  end

  def checkmate(opponent, pos = 'A1', checkmate = true)
    # Make each valid move in the game and check if player is still in check.
    @turn.pieces.each do |piece|
      next if piece.position.nil?

      og_position = piece.position

      until pos == 'H8'
        # If pos is a valid destination, move the piece there and run check
        if valid_dest?(pos, @board, piece)
          # If there is a piece at the destination temporarily sets its position to nil.
          destination = find_piece(pos, @board.board)
          destination.position = nil if destination.is_a?(GamePiece)

          piece.position = pos

          # Return false if check returns false
          checkmate = false unless king_in_check?(@turn, opponent, @board)

          # Resets the destination piece's position.
          destination.position = pos if destination.is_a?(GamePiece)
        end

        piece.position = og_position

        pos = increment_pos(pos)
      end

      pos = 'A1'
    end

    @finished = checkmate
  end

  private

  def play_turn
    # Sets the opponent player object to opp.
    opp = @turn == @player1 ? @player2 : @player1

    # Checks for checkmate.
    checkmate(opp)

    return if @finished

    # Checks for check.
    check(opp)

    if @turn.in_check
      puts "\nCheck. #{@turn.name} it's your move."
    else
      puts "\n#{@turn.name}, it's your move."
    end

    # Runs move.
    @turn.move(opp)
  end

  def change_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end

  def start_game
    intro
    @player1.choose_name
    @player2.choose_name
    @board.display_board
  end

  def increment_pos(pos)
    if pos[0] == 'H'
      "A#{increment(pos[1])}"
    else
      "#{increment(pos[0])}#{pos[1]}"
    end
  end
end
