# frozen_string_literal: true

class Users::WikisController < ApplicationController
  include Settable
  before_action :set_repository, only: %i[index]
  before_action :set_user, only: %i[index]

  def index
    if @user
      @wikis = Wiki.eager_load(:repository).where(user_id: @user.id).order(:created_at)
    else
      flash[:error] = 'ユーザーが見つかりませんでした'
      redirect_to root_path
    end
  end
end
