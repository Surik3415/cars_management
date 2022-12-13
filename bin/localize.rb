# frozen_string_literal: true

# class to locallate the app
class Localize
  PATH_TO_LOCALE_FILE = 'config/locales/'

  attr_reader :loco

  def call
    load_locales
    show_available_locales
    choose_locale
  end

  def load_locales
    I18n.load_path = ['config/locales/en.yml', 'config/locales/ua.yml']
  end

  def show_available_locales
    row = ['en'.colorize(:green), 'ua'.colorize(:green)]
    puts tabled_result(%w[English Українська], row)
  end

  def choose_locale
    loco = gets.downcase.chomp.to_sym
    until I18n.available_locales.include?(loco)
      puts tabled_result(['incorrect value'.colorize(:red)], ['try again'.colorize(:red)])
      loco = gets.downcase.chomp.to_sym
    end
    I18n.locale = loco
  end

  def tabled_result(heading, rows)
    table = Terminal::Table.new headings: [heading], rows: [rows]
    table.style = { width: 50, border_x: '=', border_i: 'x', alignment: :center }
    table
  end
end
