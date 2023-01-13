# frozen_string_literal: true

require 'bcrypt'
# Application controller
class ApplicationController
  def initialize(params = {})
    @params = params
  end
end
