# frozen_string_literal: true

require_relative 'chess/game'

# Runs a game of chess.

intro
game = Game.new
game.play

def intro
  puts <<~HEREDOC
    Welcome to Command Line Chess. The game follows
    the standard chess rules. Each player will enter
    their name at the beginning of the game. Player 1
    will control the white pieces and make the first
    move. Player 2 will control the black pieces.

    At the beginning of each turn, the player will be
    prompted to enter the coordinates of the piece to
    be moved. Players will enter the column followed
    by the row in the format A1, corresponding to the
    piece found at that coordinate. The board will
    appear in the following configuration:

        A   B   C   D   E   F   G   H
      1| # | # | # | # | # | # | # | # |
      2| # | # | # | # | # | # | # | # |
      3| # | # | # | # | # | # | # | # |
      4| # | # | # | # | # | # | # | # |
      5| # | # | # | # | # | # | # | # |
      6| # | # | # | # | # | # | # | # |
      7| # | # | # | # | # | # | # | # |
      8| # | # | # | # | # | # | # | # |

    If player attempts an invalid move, they will be
    prompted to make a different move or move a different
    piece. Instructions for moving pieces occur during
    every turn. 

    The game will indicate when a player is in check, and
    will not allow the player to make a move unless it
    removes them from check. The game will declare a winner
    upon checkmate and end the game.

  HEREDOC
end