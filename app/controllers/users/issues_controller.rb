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
                @user.assigned_issues
              when 'reviewed'
                @user.reviewed_issues
              else
                @user.issues
              end

    @issues.where(repository_id: @repository.id).includes(:repository, :labels).order(:created_at) if @issues.any?
  end
end
