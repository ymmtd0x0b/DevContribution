# frozen_string_literal: true

class Assign < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true

  class << self
    def synchronize(model_name, items, user)
      user.assigns.where(assignable_type: model_name).where.not(assignable_id: items.map(&:id)).delete_all

      hash_list = items.map { |item| { assignable_type: model_name, assignable_id: item.id, user_id: user.id } }
      insert_all(hash_list, unique_by: %i[assignable_type assignable_id user_id]) if hash_list.any?
    end
  end
end
