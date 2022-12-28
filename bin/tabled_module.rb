# frozen_string_literal: true

# class that show result in the table
module TabledModule
  def tabled_result(heading, rows)
    table = Terminal::Table.new title: "#{I18n.t(:"#{heading}")}:".to_s.colorize(:light_green), rows: rows
    table.style = { border_x: '=', border_i: 'x' }
    puts table
  end
end
