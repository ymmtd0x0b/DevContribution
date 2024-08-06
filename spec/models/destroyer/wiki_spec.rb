# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::Wiki, type: :model do
  describe '#call' do
    it 'ユーザーが作成者である Wiki を全て削除すること' do
      FactoryBot.create(:repository, id: 1)

      taro = FactoryBot.create(:user, id: 123, login: 'taro')
      FactoryBot.create_list(:wiki, 2, :with_repository, :with_user, repository_id: 1, user_id: 123)

      jiro = FactoryBot.create(:user, id: 456, login: 'jiro')
      FactoryBot.create_list(:wiki, 2, :with_repository, :with_user, repository_id: 1, user_id: 456)

      expect { Destroyer::Wiki.new.call(taro) }.to change { taro.wikis.count }.from(2).to(0)
                                               .and not_change { jiro.wikis.count }.from(2)
    end
  end
end
