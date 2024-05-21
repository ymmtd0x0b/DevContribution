# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequest, type: :model do
  it '有効なファクトリを持つこと' do
    pull_request = FactoryBot.create(:pull_request)
    expect(pull_request).to be_valid
  end

  describe '#assignee?' do
    context 'ユーザーがアサインされている場合' do
      it 'true を返すこと' do
        user = FactoryBot.create(:user)
        pull_request = FactoryBot.create(:pull_request) { |pr| pr.assigns.create!(user_id: user.id) }

        expect(pull_request.assignee?(user)).to eq true
      end
    end

    context 'ユーザーがアサインされていない場合' do
      it 'false を返すこと' do
        user = FactoryBot.create(:user)
        pull_request = FactoryBot.create(:pull_request)

        expect(pull_request.assignee?(user)).to eq false
      end
    end
  end
end
