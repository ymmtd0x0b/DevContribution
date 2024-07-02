# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    name { 'test/repository' }
    url { 'https://example.com/test/repository' }
    avatar_url { 'https://example.com/test/repository.jpg' }
  end
end
