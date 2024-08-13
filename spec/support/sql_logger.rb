# frozen_string_literal: true

ActiveRecord::Base.logger = Logger.new($stdout) if ENV['RSPEC_LOG']
