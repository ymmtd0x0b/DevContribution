# frozen_string_literal: true

module IssueDecorator
  def url
    base_url = ENV['GITHUB_URL']
    "#{base_url}/#{repository.name}/issues/#{number}"
  end

  def point
    labels.pluck(:name).map(&:to_i).sum
  end
end
