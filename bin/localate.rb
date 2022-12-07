# frozen_string_literal: true

# class to locallate the app
class Localate
  attr_reader :loco

  def call
    chose_language
    loco_validator
  end

  def chose_language
    row = [['en'.colorize(:green), 'ua'.colorize(:green)]]
    table = Terminal::Table.new headings: %w[English Українська], rows: row
    table.style = { width: 40, border_x: '=', border_i: 'x', alignment: :center }
    I18n.load_path = ['config/locales/en.yml', 'config/locales/ua.yml']
    I18n.t('greatint')
    puts table
  end

  def loco_validator
    loco = gets.downcase.chomp.to_sym
    table = Terminal::Table.new headings: [['incorrect value'.upcase.colorize(:red)]],
                                rows: [['try again'.colorize(:red)]]
    table.style = { width: 40, border_x: '=', border_i: 'x', alignment: :center }
    until I18n.available_locales.include?(loco)
      puts table
      loco = gets.downcase.chomp.to_sym
    end
    I18n.locale = loco
  end
end
