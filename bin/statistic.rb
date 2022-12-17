# frozen_string_literal: true

# class that creates a collection with statistical information and search results
class Statistic
  attr_reader :info_to_save, :statistic_info, :db_file

  def initialize(result_of_search, rules, statistic_and_rules_collection)
    # loading the necessary output data for work
    @result_of_search = result_of_search
    @rules = rules
    @statistic_and_rules_collection = statistic_and_rules_collection
    # creating an hash for adding statistical information and search rules
    @statistic_info = {}
    # the final collection of information that will be added to the database
    @info_to_save = []
  end

  def call
    search_info_to_save
    safe_to_file
  end

  def search_info_to_save
    @statistic_info['total_quantity_of_cars'] = @result_of_search.length
    @statistic_info['quantity_of_request'] = 1
    @statistic_info['request_params'] = @rules
    YAML.load_stream(File.open(@statistic_and_rules_collection.yalm_file, 'a+')) do |request|
      @statistic_info['quantity_of_request'] += 1 if request[0]['request_params'] == @rules
    end
    @info_to_save << @statistic_info
  end

  def safe_to_file
    @statistic_and_rules_collection.record(@info_to_save)
  end
end
