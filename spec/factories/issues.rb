# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:title) { |n| "issue#{n}" }
    sequence(:number)
    # 自作サービスの性質上、Issue 登録時に作成者のユーザーがデータベース上に存在するとは限らないので、
    # 基本は"存在しない"とするために :build_stubbed オプションを使用している
    association :user, strategy: :build_stubbed

    trait :with_repository do
      association :repository
    end
  end
end
