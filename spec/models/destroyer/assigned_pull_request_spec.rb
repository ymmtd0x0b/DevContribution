# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::AssignedPullRequest, type: :model do
  describe '#call' do
    let(:assigned_pull_request_destroyer) { Destroyer::AssignedPullRequest.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    it 'ユーザーがアサインしている PullRequest の内、「他のユーザーが参照していないもの」は「削除する」こと' do
      FactoryBot.create(:pull_request) { |pull_request| pull_request.assigns.create!(user: alice) }
      FactoryBot.create(:pull_request) do |pull_request|
        pull_request.assigns.create!(user: alice)
        pull_request.reviews.create!(user: alice)
      end

      expect { assigned_pull_request_destroyer.call(alice) }.to change { alice.assigned_pull_requests.count }.from(2).to(0)
                                                            .and change { PullRequest.count }.by(-2)
    end

    it 'ユーザーがアサインしている PullRequest の内、「他のユーザーが参照しているもの」は「削除しない」こと' do
      FactoryBot.create(:pull_request) do |pull_request|
        pull_request.assigns.create!(user: alice)
        pull_request.assigns.create!(user: bob)
      end

      FactoryBot.create(:pull_request) do |pull_request|
        pull_request.assigns.create!(user: alice)
        pull_request.reviews.create!(user: bob)
      end

      expect { assigned_pull_request_destroyer.call(alice) }.not_to change { alice.assigned_pull_requests.count }.from(2)
    end
  end
end
