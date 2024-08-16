# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

gem 'active_decorator'
gem 'bootsnap', require: false
gem 'chroma'
gem 'dotenv-rails'
gem 'font-awesome-sass'
gem 'git'
gem 'github_api'
gem 'high_voltage'
gem 'importmap-rails'
gem 'jbuilder'
gem 'meta-tags'
gem 'newspaper'
gem 'octokit'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.6'
gem 'redcarpet'
gem 'slim'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
end

group :development do
  gem 'rspec-rails'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-fjord', require: false
  gem 'rubocop-rails', require: false
  gem 'slim_lint'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webdrivers', '= 5.3.0' # bundle update 時のメッセージ対策ためバージョンを固定
  gem 'webmock'
end
