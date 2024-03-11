class Repositories::WikisController < ApplicationController
  include Settable
  before_action :set_registed_repositories, :set_repository, :set_registration, only: %i[index]

  def index
    @wikis = current_user.created_wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
