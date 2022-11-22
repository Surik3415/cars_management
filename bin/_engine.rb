
require 'yaml'
require 'date'
require_relative 'input_colector'
require_relative 'filter'
require_relative 'sort'
require_relative 'statistic'
require_relative 'show_result'

#class that collects all code components with all available functionality
class Run_app

    def initialize car_file_db, file_to_record
        
        #save content of the file with existing cars
        @car_file_collection = YAML.safe_load_file(car_file_db)
        #collection of data from the user
        @rules = Input_colector.new.rules
        #variable with the filtered search result
        @result_of_search = Filter.new(@car_file_collection, @rules).result_of_search 

        #sorting the contents of @result_of_search according to the specified rules
        Sort.new(@rules, @result_of_search)

        #variable with statistical information
        @statistic_and_rules_collection = File.open(file_to_record,"a+")
        #formation of statistical information
        @statistic_info = Statistic.new(@result_of_search, @rules, @statistic_and_rules_collection).statistic_info
        #creating a file that will be written to @statistic_and_rules_collection
        @info_to_save = Statistic.new(@result_of_search, @rules, @statistic_and_rules_collection).info_to_save
        #storing a collection with search rules and statistical information
        @statistic_and_rules_collection.puts YAML.dump(@info_to_save)

        #output to the console an information based on search results
        Show_result.new(@statistic_info, @result_of_search)

    end

end

