# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retirements', type: :system do
  scenario '退会できること' do
    FactoryBot.create(:repository, id: 123)
    alice = FactoryBot.create(:user, login: 'alice')

    login_as alice
    expect do
      using_wait_time(5) do # フラッシュメッセージとログアウトボタンが重なるので、メッセージが閉じるまで待つ
        click_button 'alice'
        click_link 'アカウントを削除'
        click_button 'OK', class: 'swal2-confirm'
      end

      expect(page).to have_current_path '/'
      expect(page).to have_content 'アカウントの連携を解除しました'
    end.to change { User.count }.by(-1)
  end
end
