# frozen_string_literal: true

class Assign < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true

  class << self
    def bulk_insert(model_name, items, user)
      return nil if user.nil?

      if items.empty?
        user.assigns.where(assignable_type: model_name).destroy_all
      else
        user.assigns
            .where('assignable_type = ? and assignable_id not in (?)', model_name, items.map(&:id))
            .destroy_all

        assigns_data = items.map { |item| { assignable_type: model_name, assignable_id: item.id, user_id: user.id } }
        upsert_all assigns_data, unique_by: %i[assignable_id user_id]
      end
    end
  end
end
