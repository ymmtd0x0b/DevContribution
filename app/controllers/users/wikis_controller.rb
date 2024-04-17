class Users::WikisController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    @user = User.find_by(login: params[:user_login])
    @wikis = @user.wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
