class CurrentUser::WikisController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]

  def index
    @wikis = current_user.created_wikis.where(repository_id: @repository.id).order(:created_at)
  end
end
