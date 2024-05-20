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
                User.includes(assigned_issues: %i[repository labels]).find(@user.id).assigned_issues
              when 'reviewed'
                @user.reviewed_issues
              else
                User.includes(issues: %i[repository labels]).find(@user.id).issues
              end
  end
end
