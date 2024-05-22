# frozen_string_literal: true

class Users::IssuesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]
  before_action :set_user, only: %i[index]

  def index
    if @user
      set_issues
    else
      flash[:error] = 'ユーザーが見つかりませんでした'
      redirect_to root_path
    end
  end

  private

  def set_issues
    @issues = case params[:association]
              when 'assigned'
                Issue.eager_load(:repository).preload(:labels).joins(:assigns).where('assigns.user_id = ?', @user.id).order(:id)
              when 'reviewed'
                Issue.eager_load(:repository).preload(:labels).joins(pull_requests: :reviews).where('reviews.user_id = ?', @user.id).order(:id)
              else
                Issue.eager_load(:repository).preload(:labels).where(user_id: @user.id).order(:id)
              end
  end
end
