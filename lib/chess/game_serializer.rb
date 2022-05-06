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
end