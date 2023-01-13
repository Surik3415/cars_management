# frozen_string_literal: true

require_relative '../tabled_module'
require 'bcrypt'

# Session controller
class SessionController < ApplicationController
  FILE_PATH = 'yaml_db/users.yml'
  attr_accessor :current_user

  include TabledModule
  @current_user = false

  def sign_up
    ask_email
    ask_pass
    # info_checker
    # collect_user_info
    @current_user = @email
    save_new_user
  end

  def log_in
    ask_email
    user = UsersController.new.check_email('email', @email)
    return unless user

    ask_pass
    return unless UsersController.new.check_password(user, @password)

    @current_user = @email
  end

  def log_out
    @current_user = false
  end

  def ask_pass
    print "#{I18n.t(:'autorization.password')}\n"
    @password = gets.chomp
    return if @password.match?(/\W{2,}/) && @password.match?(/.{8,20}/) && @password.match?(/[[:upper:]]+/)

    tabled_result('validators.validator_wrong', [[I18n.t(:'validators.password_requirements')]])
    ask_pass
  end

  def ask_email
    print "#{I18n.t(:'autorization.email')} \n"
    @email = gets.chomp
    return if @email.match?(/\w{5,}@\w+\.\w+/)

    tabled_result('validators.validator_wrong', [[I18n.t(:'validators.email_requirements')]])
    ask_email
  end

  def save_new_user
    user = UsersController.new({ 'email' => @email, 'password' => BCrypt::Password.create(@password) })
    user.create
  end
end
