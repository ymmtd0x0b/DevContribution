# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PrivacyPolicy', type: :system do
  scenario 'プライバシーポリシーを表示する' do
    FactoryBot.create(:repository, id: 123)
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
