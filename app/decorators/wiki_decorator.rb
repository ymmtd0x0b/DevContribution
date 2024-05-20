# frozen_string_literal: true

module WikiDecorator
  def url
    "#{repository.url}/wiki/#{title}"
  end
end
