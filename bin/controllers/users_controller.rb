# frozen_string_literal: true

require_relative 'application_controller'
require 'bcrypt'

# Users controller
class UsersController < ApplicationController
  attr_accessor :params

  def create
    database.update(params)
  end

  def check_email(param, value)
    database.find_by(param, value)
  end

  def check_password(user, password)
    user['password'] == password
  end

  private

  def database
    User.new
  end
end
