require 'bcrypt'
require_relative 'tabled_module'

#main comment
class User
  FILE_PATH = 'yaml_db/users.yml'

  attr_accessor :email, :password, :user_info

  include TabledModule

  def initialize(user_file)
    @user_file = user_file
    call
  end

  def call
    enter_email
    enter_password
    collect_user_info
    # save_info
  end

  def enter_email
    print "#{I18n.t(:'autorization.email')} \n"
    @email = gets.chomp
    return if @email.match?(/\w{5,}@\w+\.\w+/)

    tabled_result('validators.validator_wrong', [[I18n.t(:'validators.email_requirements')]])
    enter_email
  end

  def enter_password
    print "#{I18n.t(:'autorization.password')} \n"
    @password = gets.chomp
    return if @password.match?(/\W{2,}/) && @password.match?(/.{8,20}/) && @password.match?(/[[:upper:]]+/)

    tabled_result('validators.validator_wrong', [[I18n.t(:'validators.password_requirements')]])
    enter_password
  end

  def collect_user_info
    @user_info = []
    @hased_pass = BCrypt::Password.create(@password)
    @user_info << @email << @hased_pass
  end

  # def save_info
  #   Recorder.new(FILE_PATH).record(@user_info)
  # end
end
