# frozen_string_literal: true

class RetirementController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[create]

  def create
    Newspaper.publish(:user_destroy, { repository: @repository, user: current_user })
    current_user.destroy!
    reset_session
    flash[:success] = 'アカウントの連携を解除しました'
    redirect_to root_path
  end
end
