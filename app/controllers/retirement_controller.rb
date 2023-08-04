class RetirementController < ApplicationController
  def create
    current_user.destroy!
    reset_session
    redirect_to root_path, notice: 'アカウントの連携を解除しました'
  end
end
