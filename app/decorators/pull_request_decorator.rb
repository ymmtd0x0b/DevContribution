# frozen_string_literal: true

module PullRequestDecorator
  def url
    "#{repository.url}/pull/#{number}"
  end
end
