# frozen_string_literal: true

FactoryBot.define do
  factory :pull_request do
    sequence(:number)
    association :repository
  end
end
