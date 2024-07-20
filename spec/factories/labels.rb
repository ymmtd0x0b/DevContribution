# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "bug#{n}" }
    color { 'FF0000' }

    trait :with_repository do
      association :repository
    end
  end
end
