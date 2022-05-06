# frozen_string_literal: true

require_relative 'chess/game'
require_relative 'chess/game_serializer'

# Runs a game of chess.

include GameSerializer

puts <<~HEREDOC

  Welcome to Command Line Chess.

  # Game instructions

  If you would like to start a new game press [1].
  If you would like to load a saved game press [2].
  
HEREDOC


game = pick_game
game.play
