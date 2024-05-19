# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "tester#{n}" }
    avatar_url { 'https://example.com/12345.jpg' }
  end
end
