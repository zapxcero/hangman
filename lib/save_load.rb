# frozen_string_literal: true

# Loads and saves game
module Load
  def serialize(obj)
    obj.dict = nil
    YAML.dump(obj)
  end

  def deserialize(yaml_str, class_type)
    YAML.safe_load(yaml_str, permitted_classes: [class_type])
  end

  def save
    file_name = "save_#{Random.new_seed}.yaml"
    saved = File.open(file_name, 'w')
    saved.puts serialize
    self.game_running = false
  end

  def load
    deserialize(File.open(saved_file, 'r').read)
  end

  def run_load
    cont_game = load
    cont_game.dict = filter_dict
    cont_game.round
  end

  def save_files
    Dir['./**/*.yaml']
  end

  def list_saves
    save_files.each_with_index { |save, index| puts "#{index}. #{save}" }
  end

  def saved_file
    list_saves
    puts 'Enter which save file to load: '
    choice = gets.chomp.to_i
    save_files[choice]
  end
end
