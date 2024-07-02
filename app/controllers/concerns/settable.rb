# frozen_string_literal: true

module Settable
  def set_repository
    @repository = Repository.find_by(id: ENV['REPOSITORY_ID'])
  end

  def set_user
    @user = User.find_by(login: params[:user_login])
  end
end
