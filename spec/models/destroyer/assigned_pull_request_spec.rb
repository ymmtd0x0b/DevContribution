# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::AssignedPullRequest, type: :model do
  describe '#call' do
    let(:assigned_pull_request_destroyer) { Destroyer::AssignedPullRequest.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーがアサインしている PullRequest の内、他のユーザーが参照していないのは削除すること' do
      FactoryBot.create(:pull_request, id: 100) { |pull_request| pull_request.assigns.create!(user: alice) }
      FactoryBot.create(:pull_request, id: 200) do |pull_request|
        pull_request.assigns.create!(user: alice)
        pull_request.reviews.create!(user: alice)
      end

      expect { assigned_pull_request_destroyer.call(alice) }.to change { PullRequest.pluck(:id) }.from([100, 200]).to([])
    end

    it 'ユーザーがアサインしている PullRequest の内、他のユーザーが参照しているのは削除しないこと' do
      FactoryBot.create(:pull_request, id: 100) do |pull_request|
        pull_request.assigns.create!(user: alice)
        pull_request.assigns.create!(user: bob)
      end

      FactoryBot.create(:pull_request, id: 200) do |pull_request|
        pull_request.assigns.create!(user: alice)
        pull_request.reviews.create!(user: bob)
      end

      expect { assigned_pull_request_destroyer.call(alice) }.not_to change { PullRequest.pluck(:id) }.from([100, 200])
    end
  end
end
