# frozen_string_literal: true

require_relative 'tabled_module'
require_relative 'autorization'
require 'bcrypt'

# show my resulp in console
class MainMenu
  include TabledModule

  def initialize
    Localize.new.call
    @session = SessionController.new
    call
  end

  def call
    show_options
    # user_menu
    chose_option
    compere
  end

  def show_options # rubocop:disable Metrics/MethodLength
    row = []
    options = [1, 2, 3, 4]
    options.each do |el|
      row << [I18n.t(:"main_menu.options.option_#{el}"), el]
    end
    if @session.current_user
      row << [I18n.t(:"autorization.log_out"), '5']
    else
      row << [I18n.t(:"autorization.log_in"), '5'] << [I18n.t(:"autorization.sing_up"), '6']
    end
    tabled_result('main_menu.greating', row)
  end

  def chose_option
    @chosen_option = gets.chomp
  end

  def compere # rubocop:disable Metrics/MethodLength
    case @chosen_option
    when '1', '2'
      reserch_feature
    when '3', '4'
      menu_feature
    when '5', '6'
      session_feature
    else
      error
    end
    call
  end

  def reserch_feature
    case @chosen_option
    when '1'
      search_a_car
    when '2'
      show_all_cars
    end
  end

  def menu_feature
    case @chosen_option
    when '3'
      help
    when '4'
      exit_from_app
    end
  end

  def session_feature
    case @chosen_option
    when '5'
      @session.current_user ? @session.log_out : @session.log_in
    when '6'
      @session.sign_up
    end
  end

  def search_a_car
    RunApp.new.call
  end

  def show_all_cars
    car_file_collection = Recorder.new('yaml_db/db_of_cars/cars.yml').fetch
    separeted_cars = []
    car_file_collection.map do |car|
      car.map do |key, value|
        separeted_cars.push([I18n.t(:"car_about.#{key}").to_s.colorize(:light_green),
                             value.to_s.colorize(:light_green)])
        separeted_cars << :separator if key == 'date_added'
      end
    end
    tabled_result('show_result.result', separeted_cars)
  end

  def help
    help_message = I18n.t(:'main_menu.help').colorize(:blue)
    print "#{help_message}\n"
  end

  def exit_from_app
    exit_message = I18n.t(:'main_menu.exit').colorize(:yellow)
    print "#{exit_message}\n"
    exit!
  end

  def error
    error_message = I18n.t(:'main_menu.error_message').colorize(:red)
    print "#{error_message}\n"
  end
end
