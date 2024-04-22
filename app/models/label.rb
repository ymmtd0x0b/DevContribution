# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :repository

  validates :name,  presence: true
  validates :color, presence: true
end
