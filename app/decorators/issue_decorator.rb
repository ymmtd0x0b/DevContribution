# frozen_string_literal: true

module IssueDecorator
  def url
    "#{repository.url}/issues/#{number}"
  end
end
