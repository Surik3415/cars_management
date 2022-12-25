# frozen_string_literal: true

# class that show result in the table
module TabledModule
  def tabled_result(heading, rows, *text_align)
    table = Terminal::Table.new title: "#{I18n.t(:"#{heading}")}:".to_s.colorize(:light_green), rows: rows
    table.style = { width: 90, padding_left: 3, border_x: '=', border_i: 'x', alignment: text_align[0] }
    puts table
  end
end
