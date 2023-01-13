# frozen_string_literal: true

# class for filtering a collection of cars by specified parameters
class Filter
  attr_reader :result_of_search

  def initialize(car_file_collection, rules)
    @rules = rules
    @result_of_search = car_file_collection.fetch
  end

  def call
    filter_by_exact_value
    filter_by_relative_values('price')
    filter_by_relative_values('year')
  end

  def filter_by_exact_value
    same_rules = @result_of_search[0].keys & @rules.keys
    same_rules.each do |rule|
      skip_by_empty_value = @rules[rule] == ''
      @result_of_search.keep_if { |car| car[rule].upcase == @rules[rule].upcase || skip_by_empty_value }
    end
  end

  def filter_by_relative_values(rule)
    from = @rules["#{rule}_from"]
    to = @rules["#{rule}_to"]

    skip_by_empty_from = from == ''
    skip_by_empty_to = to == ''

    @result_of_search.keep_if do |car|
      (car[rule] >= from.to_i || skip_by_empty_from) && (car[rule] <= to.to_i || skip_by_empty_to)
    end
  end
end
