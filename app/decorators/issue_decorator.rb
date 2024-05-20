# frozen_string_literal: true

module IssueDecorator
  def url
    "#{repository.url}/issues/#{number}"
  end

  def point
    labels.pluck(:name).map(&:to_i).sum
  end
end
