# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retirements', type: :system do
  before do
    FactoryBot.create(:repository, id: 123)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('REPOSITORY_ID').and_return('123')
  end

  scenario '退会できること' do
    alice = FactoryBot.create(:user, login: 'alice')

    visit_with_omniauth(path: root_path, user: alice)

    expect do
      click_button 'alice'
      click_link 'アカウントを削除'
      click_button 'OK', class: 'swal2-confirm'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'アカウントの連携を解除しました'
    end.to change { User.count }.by(-1)
  end
end
