# frozen_string_literal: true

class Users::IssuesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]
  before_action :set_user, only: %i[index]

  def index
    if @user
      refined_issues =
        case params[:association]
        when 'assigned'
          @user.assigned_issues
        when 'reviewed'
          @user.reviewed_issues
        else
          @user.issues
        end
      @issues = refined_issues.where(repository_id: @repository.id).includes(:repository, :labels).order(:created_at)
    else
      flash[:error] = 'ユーザーが見つかりませんでした'
      redirect_to root_path
    end
  end
end
