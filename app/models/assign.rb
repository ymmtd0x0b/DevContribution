# frozen_string_literal: true

class Assign < ApplicationRecord
  belongs_to :user
  belongs_to :assignable, polymorphic: true

  class << self
    def synchronize(model_name, items, user)
      if items.empty?
        user.assigns.where(assignable_type: model_name).delete_all
      else
        user.assigns
            .where('assignable_type = ? and assignable_id not in (?)', model_name, items.map(&:id))
            .delete_all

        assigns_hash_list = items.map { |item| { assignable_type: model_name, assignable_id: item.id, user_id: user.id } }
        insert_all(assigns_hash_list, unique_by: %i[assignable_id user_id])
      end
    end
  end
end
