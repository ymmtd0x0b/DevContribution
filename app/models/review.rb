# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  class << self
    def bulk_insert(model_name, items, user)
      if items.empty?
        user.reviews.where(reviewable_type: model_name).destroy_all
      else
        user.reviews
            .where('reviewable_type = ? and reviewable_id not in (?)', model_name, items.map(&:id))
            .destroy_all

        reviews_data = items.map { |item| { reviewable_type: model_name, reviewable_id: item.id, user_id: user.id } }
        upsert_all reviews_data, unique_by: %i[reviewable_id user_id]
      end
    end
  end
end
