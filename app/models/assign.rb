class Assign < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true
end
