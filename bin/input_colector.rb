# frozen_string_literal: true

# class to collect information from the user
class InputColector
  SEARCH_CRITERIA = %w[make model year_from year_to price_from price_to].freeze

  attr_accessor :rules

  def initialize
    @rules = {}
  end

  def call
    collect_inputs
    collect_sort_params
  end

  def collect_inputs
    SEARCH_CRITERIA.each do |criteria|
      puts "#{I18n.t(:offer)} #{I18n.t(:"car_about.#{criteria}")}:".colorize(:magenta)
      @rules[criteria] = gets.chomp
    end
  end

  def collect_sort_params
    puts "#{I18n.t(:offer)} #{I18n.t(:"sort.option")}:".colorize(:magenta)
    order_by = gets.chomp
    @rules['order_by'] = order_by
    puts "#{I18n.t(:offer)} #{I18n.t(:"sort.direction")}:".colorize(:magenta)
    order_direction = gets.chomp
    @rules['order_direction'] = order_direction
  end
end
