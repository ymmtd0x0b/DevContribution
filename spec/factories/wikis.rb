# frozen_string_literal: true

FactoryBot.define do
  factory :wiki do
    sequence(:title) { |n| "wiki#{n}" }
    first_commit_hash { Digest::SHA1.hexdigest(rand(100).to_s) }
    association :repository
    association :user
  end
end
