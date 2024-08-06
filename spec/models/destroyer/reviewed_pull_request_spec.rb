# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::ReviewedPullRequest, type: :model do
  describe '#call' do
    before do
      FactoryBot.create(:repository, id: 1)
    end

    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    context '対象の PullRequest が「他のユーザーから参照されていない」場合' do
      it 'ユーザーがレビューしている PullRequest を削除すること (本人のみレビューしている)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1) { |pr| pr.reviewers << alice }

        expect { Destroyer::ReviewedPullRequest.new.call(alice) }.to change { alice.reviewed_pull_requests.count }.from(1).to(0)
                                                                 .and change { PullRequest.count }.by(-1)
      end

      it 'ユーザーがレビューしている PullRequest を削除すること (本人のみアサインしている)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1) do |pr|
          pr.reviewers << alice
          pr.assignees << alice
        end

        expect { Destroyer::ReviewedPullRequest.new.call(alice) }.to change { alice.reviewed_pull_requests.count }.from(1).to(0)
                                                                 .and change { PullRequest.count }.by(-1)
      end
    end

    context '対象の PullRequest が「他のユーザーから参照されている」場合' do
      it 'ユーザーがレビューしている PullRequest を削除しないこと (他のユーザーもレビューしている)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1) do |pr|
          pr.reviews.create!(user: alice)
          pr.reviews.create!(user: bob)
        end

        expect { Destroyer::ReviewedPullRequest.new.call(alice) }.not_to change { alice.reviewed_pull_requests.count }.from(1)
      end

      it 'ユーザーがレビューしている PullRequest を削除しないこと (他のユーザーがアサインしている)' do
        FactoryBot.create(:pull_request, :with_repository, repository_id: 1) do |pr|
          pr.reviews.create!(user: alice)
          pr.assigns.create!(user: bob)
        end

        expect { Destroyer::ReviewedPullRequest.new.call(alice) }.not_to change { alice.reviewed_pull_requests.count }.from(1)
      end
    end
  end
end
