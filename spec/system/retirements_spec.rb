# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retirements', type: :system do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('123')

    FactoryBot.create(:repository, id: 123)
    FactoryBot.create(:user, id: 123_45, login: 'alice')
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github',
                                                                  uid: 123_45,
                                                                  info: { nickname: 'alice',
                                                                          name: 'アリス',
                                                                          image: 'https://example.com/avatar.jpg' } })
    allow(Newspaper).to receive(:publish)
  end

  scenario '退会できること' do
    visit root_path
    click_button 'ログイン'

    using_wait_time(5) do
      expect do
        click_button 'alice'
        click_link 'アカウントを削除'
        click_button 'OK', class: 'swal2-confirm'

        expect(page).to have_current_path '/'
        expect(page).to have_content 'アカウントの連携を解除しました'
      end.to change { User.count }.by(-1)
    end
  end
end
