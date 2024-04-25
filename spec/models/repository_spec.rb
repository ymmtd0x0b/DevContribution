# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  it '有効なファクトリを持つこと' do
    repository = FactoryBot.build(:repository)
    expect(repository).to be_valid
  end

  it 'name, url があれば有効であること' do
    repository = Repository.new(name: 'test', url: 'https://example.com/test')
    expect(repository).to be_valid
  end
end
