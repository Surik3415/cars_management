# frozen_string_literal: true

# class to collect information from the user
class InputColector
  SEARCH_CRITERIA = %w[make model year_from year_to price_from price_to].freeze

  attr_reader :rules

  def initialize
    @rules = {}
    collect_inputs
  end

  def collect_inputs
    SEARCH_CRITERIA.each do |criteria|
      puts "Please choose #{criteria}:"
      @rules[criteria] = gets.chomp
    end

    puts('Please choose sort option (date_added|price):')
    order_by = gets.chomp
    @rules['order_by'] = order_by

    puts('Please choose sort direction(desc|asc):')
    order_direction = gets.chomp
    @rules['order_direction'] = order_direction
  end
end
