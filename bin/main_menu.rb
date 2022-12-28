# frozen_string_literal: true

require_relative 'tabled_module'
require_relative 'autorization'
require 'bcrypt'

# show my resulp in console
class MainMenu
  include TabledModule

  def initialize
    Localize.new.call
    call
  end

  def call
    show_options
    # user_menu
    chose_option
    compere
  end

  def show_options
    options = [1, 2, 3, 4, 5]
    row = []
    options.each do |el|
      row << [I18n.t(:"main_menu.options.option_#{el}"), el]
    end
    tabled_result('main_menu.greating', row)
  end

  # def user_menu
  #   if @user.autorization
  #     row << [I18n.t(:"main_menu.autorization.log_out"), '0']
  #     tabled_result('main_menu.greating', row)
  #   else
  #     row << [I18n.t(:"main_menu.autorization.log_in"), '0']
  #     tabled_result('main_menu.greating', row)
  #   end
  # end

  def chose_option
    @chosen_option = gets.chomp
  end

  def compere # rubocop:disable Metrics/MethodLength
    case @chosen_option
    when '1'
      search_a_car
      call
    when '2'
      show_all_cars
      call
    when '3'
      help
      call
    when '4'
      exit_from_app
    when '5'
      @user = Autorization.new(User.new('yaml_db/users.yml'))
      call
    else
      error
      call
    end
  end

  def search_a_car
    RunApp.new.call
  end

  def show_all_cars
    car_file_collection = Recorder.new('yaml_db/db_of_cars/cars.yml').load
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
