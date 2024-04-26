# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    sequence(:id) { |n| n }
    name { 'bug' }
    color { 'FF0000' }
    association :repository
  end
end
