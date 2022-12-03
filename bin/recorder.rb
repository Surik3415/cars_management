# frozen_string_literal: true

# class to record information from the user
class Recorder
  attr_accessor :yalm_file

  def initialize(yalm_file)
    @yalm_file = yalm_file
  end

  def load
    YAML.safe_load_file(@yalm_file)
  end

  def record(modifyded_data)
    File.open(@yalm_file, 'a+') { |file| file.write(modifyded_data.to_yaml) }
  end

  def load_a_stream
    YAML.load_stream(@yalm_file)
  end
end
