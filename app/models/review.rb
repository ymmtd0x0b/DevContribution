# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :pull_request
end
