# frozen_string_literal: true

require 'json'

# mixin
module GameSerializer
  @@serializer = JSON

  def save
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def load(game_file)
    game_file = File.open(game_file, 'r')
    data = game_file.readline
    game_file.close
    obj = @@serializer.parse(data)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end

  def name_file
    i = 1
    fname = gets.chomp.strip
    original_fname = fname
    while File.exist?("saved_games/#{fname}.json")
      fname = original_fname + "(#{i})"
      i += 1
    end

    fname.gsub(' ', '_')
  end

  def create_game_file(fname)
    game_file = File.open("saved_games/#{fname}.json", 'w')
    data = save
    game_file.write(data)
    game_file.close
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    puts "\nEnter a name for your save game:\n"

    create_game_file(name_file)
  end

  def show_saved_games(games)
    puts "\nSaved Games:\n"

    games.each_with_index do |fname, i|
      puts "#{i + 1}: #{fname}\n"
    end

    puts "\Enter the number of the game you would like to load.\n"
  end

  def check_for_saved_games
    if Dir.exist?('saved_games') && !Dir.empty('saved_games/*')
      saved_games = Dir.glob('saved_games/*')
      show_saved_games(saved_games)
      saved_game = gets.chomp.to_i - 1
      game = Game.new
      game.load(saved_games[saved_game])

    else
      puts "You don't have any saved games. Starting a new game.\n"
      Game.new
    end
  end

  def pick_game
    case gets.chomp
    when '1'
      game = Game.new
    when '2'
      game = check_for_saved_games
    else
      puts "\nPlease enter 1 or 2:\n"
      game = pick_game
    end

    game
  end
end
