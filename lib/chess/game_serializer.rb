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
end
