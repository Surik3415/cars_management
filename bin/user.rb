# frozen_string_literal: true

# User Model
class User
  def load_all_users
    @users = database.fetch
  end

  def find_by(param, value)
    load_all_users
    @users.find { |user| user[param] == value }
  end

  def update(user)
    load_all_users
    @users << user
    database.rewrite(@users)
  end

  private

  def database
    Recorder.new('yaml_db/users.yml')
  end
end
