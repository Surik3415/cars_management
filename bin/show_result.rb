# frozen_string_literal: true

require_relative 'tabled_module'
# show my resulp in console
class ShowResult
  attr_accessor :statistic_row, :requested_car

  include TabledModule
  def initialize(statistic_info, result_of_search)
    @statistic_info = statistic_info
    @result_of_search = result_of_search
  end

  def call
    show_statistic
    show_requested_car if @result_of_search != []
  end

  def show_statistic
    @statistic_row = []
    total_quantity = "#{I18n.t(:"show_result.total_quantity")}: #{@statistic_info['total_quantity_of_cars']}"
    quantity_of_request = "#{I18n.t(:"show_result.requests_quantity")}: #{@statistic_info['quantity_of_request']}"
    @statistic_row << [total_quantity.colorize(:light_green)] << [quantity_of_request.colorize(:light_green)]
    tabled_result('show_result.statistic', @statistic_row)
  end

  def show_requested_car
    @requested_car = []
    @result_of_search.map do |car|
      car.map do |key, value|
        @requested_car.push([I18n.t(:"car_about.#{key}").to_s.colorize(:light_green),
                             value.to_s.colorize(:light_green)])
        @requested_car << :separator if key == 'date_added'
      end
    end
    tabled_result('show_result.result', @requested_car)
  end
end
