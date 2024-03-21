class Lazy::RegistrationsController < ApplicationController
  def new
    @registration = Registration.new
    @repositories = Github::Repository.not_registed_by(current_user)
  end
end
