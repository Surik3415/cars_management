# frozen_string_literal: true

require_relative 'bin/_engine'

RunApp.new('yaml_db/db_of_cars/cars.yml', 'yaml_db/db_for_statistic/searches.yml')
