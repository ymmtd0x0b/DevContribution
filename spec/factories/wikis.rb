# frozen_string_literal: true

FactoryBot.define do
  factory :wiki do
    sequence(:title) { |n| "wiki#{n}" }
    first_commit_hash { Digest::SHA1.hexdigest(rand(100).to_s) }

    trait :with_repository do
      association :repository
    end

    trait :with_user do
      association :user
    end
  end
end
