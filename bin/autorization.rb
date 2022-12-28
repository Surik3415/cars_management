# frozen_string_literal: true

require_relative 'user'
require 'bcrypt'
require 'yaml'
require 'i18n'

# main comment
class Autorization
  FILE_PATH = 'yaml_db/users.yml'
  attr_accessor :autorization

  def initialize(user_object)
    @user_object = user_object
    @login_pass_matches = []
    @autorization = false
    call
  end

  def call
    pass_checker
    print
    react_on_enter
  end

  def pass_checker
    open_user_file = File.open(FILE_PATH)
    YAML.load_stream(open_user_file) do |el|
      @login_pass_matches << (el[0] == @user_object.email && el[1] == @user_object.password)
    end
  end

  def react_on_enter
    error_message = "#{I18n.t(:'validators.validator_general').colorize(:red)}\n"
    greating_message = "#{I18n.t(:'autorization.hello').colorize(:blue)}, #{@user_object.email.colorize(:blue)}\n"
    if @login_pass_matches.include?(true)
      print greating_message
      @authorization = true
    else
      print error_message
    end
  end
end
