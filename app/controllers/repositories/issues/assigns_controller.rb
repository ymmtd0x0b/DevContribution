class Repositories::Issues::AssignsController < ApplicationController
  include Settable
  before_action :set_registed_repositories, :set_repository, :set_registration, only: %i[index]

  def index
    @issues = current_user.assigned_issues.where(repository_id: @repository.id).order(:created_at)
    render 'repositories/issues/index'
  end
end
