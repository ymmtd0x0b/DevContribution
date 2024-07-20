# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelDecorator, type: :model do
  describe '#border_color' do
    it 'ラベルの色をより暗く変換して返すこと' do
      label = FactoryBot.create(:label, :with_repository, color: 'FFFFFF')
      decorator_label = ActiveDecorator::Decorator.instance.decorate(label)

      expect(decorator_label.border_color).to eq '#fafafa'
    end
  end

  describe '#font_color' do
    context 'ラベルの色が明るい場合' do
      it '暗めの色(#555555)を返すこと' do
        label = FactoryBot.create(:label, :with_repository, color: 'FFFFFF')
        decorator_label = ActiveDecorator::Decorator.instance.decorate(label)

        expect(decorator_label.font_color).to eq '#555555'
      end
    end

    context 'ラベルの色が暗い場合' do
      it '明るめの色(#F8F8F8)を返すこと' do
        label = FactoryBot.create(:label, :with_repository, color: '000000')
        decorator_label = ActiveDecorator::Decorator.instance.decorate(label)

        expect(decorator_label.font_color).to eq '#F8F8F8'
      end
    end
  end
end
