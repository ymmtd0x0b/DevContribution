# frozen_string_literal: true

class RetirementController < ApplicationController
  def create
    Newspaper.publish(:user_destroy, current_user)
    current_user.destroy!
    reset_session
    flash[:success] = 'アカウントの連携を解除しました'
    redirect_to root_path
  end
end
