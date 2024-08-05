# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::AssignedPullRequest, type: :model do
  describe '#call' do
    before do
      FactoryBot.create(:repository, id: 123)
    end

    let(:assigned_pull_request_destroyer) { Destroyer::AssignedPullRequest.new }
    let(:alice) { FactoryBot.create(:user, login: 'alice') }
    let(:bob) { FactoryBot.create(:user, login: 'bob') }

    context '対象の PullRequest が「他のユーザーから参照されていない」場合' do
      it 'ユーザーがアサインしている PullRequest を削除すること (ユーザー本人のみPRにアサインしている)' do
        FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user: alice) }
        expect { assigned_pull_request_destroyer.call(alice) }.to change { alice.assigned_pull_requests.count }.from(1).to(0)
                                                              .and change { PullRequest.count }.by(-1)
      end

      it 'ユーザーがアサインしている PullRequest を削除すること (ユーザー本人のみPRをレビューしている)' do
        FactoryBot.create(:pull_request) do |pr|
          pr.assignees << alice
          pr.reviewers << alice
        end
        expect { assigned_pull_request_destroyer.call(alice) }.to change { alice.assigned_pull_requests.count }.from(1).to(0)
                                                              .and change { PullRequest.count }.by(-1)
      end
    end

    context '対象の PullRequest が「他のユーザーから参照されている」場合' do
      it 'ユーザーがアサインしている PullRequest は削除しないこと (ユーザー本人以外がアサインしている)' do
        FactoryBot.create(:pull_request) { |pr| pr.assignees << [alice, bob] }
        expect { assigned_pull_request_destroyer.call(alice) }.not_to change { alice.assigned_pull_requests.count }.from(1)
      end

      it 'ユーザーがアサインしている PullRequest は削除しないこと (ユーザー本人以外がレビューをしている)' do
        FactoryBot.create(:pull_request) do |pr|
          pr.assignees << alice
          pr.reviewers << bob
        end

        expect { assigned_pull_request_destroyer.call(alice) }.not_to change { alice.assigned_pull_requests.count }.from(1)
      end
    end
  end
end
