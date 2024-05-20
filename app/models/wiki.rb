# frozen_string_literal: true

class Wiki < ApplicationRecord
  belongs_to :user
  belongs_to :repository
end
