# frozen_string_literal: true

module LabelDecorator
  def border_color
    "##{color}".paint.darken(2).to_s
  end

  def font_color
    "##{color}".paint.dark? ? '#F8F8F8' : '#555555'
  end
end
