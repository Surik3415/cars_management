# frozen_string_literal: true

# class to record information from the user
class Recorder
  attr_accessor :yalm_file

  def initialize(yalm_file)
    @yalm_file = yalm_file
    database_setup
  end

  def fetch
    YAML.load_file(@yalm_file) || []
  end

  def record(modifyded_data)
    File.open(@yalm_file, 'a+') { |file| file.write(modifyded_data.to_yaml) }
  end

  def rewrite(rewrited_data)
    File.open(@yalm_file, 'r+') { |file| file.write(rewrited_data.to_yaml) }
  end

  def database_setup
    return fetch if File.exist?(@yalm_file)

    File.new(@yalm_file.to_s, 'w+')
  end
end
