class IssuesController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    @issues = current_user.created_issues.where(repository_id: @repository.id).order(:created_at)
  end
end
