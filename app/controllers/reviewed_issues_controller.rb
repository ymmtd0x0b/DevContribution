class ReviewedIssuesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    @issues = current_user.reviewed_issues.where(repository_id: @repository.id).order(:created_at)

    render 'issues/index'
  end
end
