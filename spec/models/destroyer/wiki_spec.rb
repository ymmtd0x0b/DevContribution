# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destroyer::Wiki, type: :model do
  describe '#call' do
    it 'ユーザーが作成者である Wiki を全て削除すること' do
      alice = FactoryBot.create(:user, login: 'alice') { |user| FactoryBot.create_list(:wiki, 2, user:) }
      expect { Destroyer::Wiki.new.call(alice) }.to change { alice.wikis.count }.from(2).to(0)
    end

    it 'ユーザーが作成者ではない Wiki は削除しないこと' do
      alice = FactoryBot.create(:user, login: 'alice') { |user| FactoryBot.create_list(:wiki, 2, user:) }
      bob = FactoryBot.create(:user, login: 'bob')
      expect { Destroyer::Wiki.new.call(bob) }.not_to change { alice.wikis.count }.from(2)
    end
  end
end
