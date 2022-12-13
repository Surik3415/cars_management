# frozen_string_literal: true

# show my resulp in console
class ShowResult
  def initialize(statistic_info, result_of_search)
    @statistic_info = statistic_info
    @result_of_search = result_of_search
  end

  def call
    show_statistic
    show_requested_car if @result_of_search != []
  end

  def show_statistic
    rows = []
    total_quantity = "#{I18n.t(:"show_result.total_quantity")}: #{@statistic_info['total_quantity_of_cars']}"
    quantity_of_request = "#{I18n.t(:"show_result.requests_quantity")}: #{@statistic_info['quantity_of_request']}"
    rows << [total_quantity.colorize(:light_green)] << [quantity_of_request.colorize(:light_green)]
    puts tabled_result('show_result.statistic', rows, :center)
  end

  def show_requested_car
    rows = []
    @result_of_search.map do |car|
      car.map do |key, value|
        rows.push([I18n.t(:"car_about.#{key}").to_s.colorize(:light_green), value.to_s.colorize(:light_green)])
        rows << :separator if key == 'date_added'
      end
    end
    puts tabled_result('show_result.result', rows)
  end

  def tabled_result(heading, rows, *text_align)
    table = Terminal::Table.new title: "#{I18n.t(:"#{heading}")}:".to_s.colorize(:light_green), rows: rows
    table.style = { width: 90, padding_left: 3, border_x: '=', border_i: 'x', alignment: text_align[0] }
    table
  end
end
