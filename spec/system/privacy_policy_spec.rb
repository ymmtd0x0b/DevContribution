# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PrivacyPolicy', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')

    FactoryBot.create(:repository, id: 101)
  end

  scenario 'プライバシーポリシーを表示する' do
    alice = FactoryBot.create(:user, login: 'alice')

    login_as alice
    visit '/privacy_policy'
    expect(page).to have_element 'h2', text: 'プライバシーポリシー'
  end

  context 'ゲストとしてアクセスした場合' do
    scenario 'プライバシーポリシーを表示する' do
      visit '/privacy_policy'
      expect(page).to have_element 'h2', text: 'プライバシーポリシー'
    end
  end
end
