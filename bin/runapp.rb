# frozen_string_literal: true

# class that collects all code components with all available functionality
class RunApp
  def call
    localate.call
    input_colector.call
    take_filter_object.call
    take_sort_object.call
    take_statistic_object.call
    show_statistic.call
  end

  def car_file_collection
    @car_file_collection = Recorder.new('yaml_db/db_of_cars/cars.yml')
  end

  def statistic_and_rules_collection
    @statistic_and_rules_collection = Recorder.new('yaml_db/db_for_statistic/searches.yml')
  end

  def input_colector
    @input_colector = InputColector.new
  end

  def take_filter_object
    @take_filter_object = Filter.new(car_file_collection, @input_colector.rules)
  end

  def take_sort_object
    @request = Sort.new(@input_colector.rules, @take_filter_object.result_of_search)
  end

  def take_statistic_object
    @take_statistic_object = Statistic.new(@take_filter_object.result_of_search, @input_colector.rules,
                                           statistic_and_rules_collection)
  end

  def show_statistic
    @show_statistic = ShowResult.new(@take_statistic_object.statistic_info, @take_filter_object.result_of_search)
  end

  def localate
    @localate = Localate.new
  end
end
