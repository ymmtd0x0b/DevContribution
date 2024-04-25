# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:title) { |n| "issue#{n}" }
    sequence(:number) { |n| n }
    association :repository
    association :user
  end
end
