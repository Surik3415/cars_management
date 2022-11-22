
require 'yaml'
require 'date'
require_relative 'input_colector'
require_relative 'filter'
require_relative 'sort'
require_relative 'statistic'
require_relative 'show_result'


class Run_app

    def initialize car_file_db, file_to_record
        
        @car_file_collection = YAML.safe_load_file(car_file_db)
        @rules = Input_colector.new.rules
        @result_of_search = Filter.new(@car_file_collection, @rules).result_of_search 

        Sort.new(@rules, @result_of_search)

        @statistic_and_rules_collection = File.open(file_to_record,"a+")
        @statistic_info = Statistic.new(@result_of_search, @rules, @statistic_and_rules_collection).statistic_info
        @info_to_save = Statistic.new(@result_of_search, @rules, @statistic_and_rules_collection).info_to_save
        @statistic_and_rules_collection.puts YAML.dump(@info_to_save)

        Show_result.new(@statistic_info, @result_of_search)

    end

end

