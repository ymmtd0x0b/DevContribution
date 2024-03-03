class RetirementController < ApplicationController
  def create
    current_user.destroy!
    reset_session
    flash[:success] = 'アカウントの連携を解除しました'
    redirect_to root_path
  end
end
