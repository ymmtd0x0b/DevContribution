# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "bug#{n}" }
    color { 'FF0000' }
    association :repository
  end
end
