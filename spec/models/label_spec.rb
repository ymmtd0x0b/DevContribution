# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  it '有効なファクトリを持つこと' do
    label = FactoryBot.build(:label)
    expect(label).to be_valid
  end

  it 'repository_id, name, color があれば有効であること' do
    repository = FactoryBot.create(:repository)
    label = Label.new(repository_id: repository.id, name: 'bug', color: 'FF0000')
    expect(label).to be_valid
  end

  describe '.bulk_insert' do
    context 'Array でまとめられた Label インスタンスが渡された場合' do
      it 'データベースへ保存すること' do
        repository = FactoryBot.create(:repository)
        labels = [
          FactoryBot.build(:label, id: 123, repository:),
          FactoryBot.build(:label, id: 456, repository:)
        ]
        expect { Label.bulk_insert(labels) }.to change(Label, :count).by(2)
      end
    end

    context '空の Array が渡された場合' do
      it 'nil を返すこと' do
        labels = []
        expect(Label.bulk_insert(labels)).to eq nil
      end
    end
  end

  describe '#to_h' do
    it 'id, repository_id, name, color を key に持つハッシュを返すこと' do
      repository = FactoryBot.create(:repository, id: 1)
      label = Label.new(id: 123, repository_id: repository.id, name: 'bug', color: 'FF0000')
      expect(label.to_h).to eq({ id: 123, repository_id: 1, name: 'bug', color: 'FF0000' })
    end
  end
end
