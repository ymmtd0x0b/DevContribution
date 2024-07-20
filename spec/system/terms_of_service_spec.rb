# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TermsOfService', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('101')

    FactoryBot.create(:repository, id: 101)
  end

  scenario '利用規約を表示する' do
    alice = FactoryBot.create(:user, login: 'alice')

    login_as alice
    visit '/terms_of_service'
    expect(page).to have_element('h2', text: '利用規約')
  end

  context 'ゲストとしてアクセスした場合' do
    scenario '利用規約を表示する' do
      visit '/terms_of_service'
      expect(page).to have_element('h2', text: '利用規約')
    end
  end
end
