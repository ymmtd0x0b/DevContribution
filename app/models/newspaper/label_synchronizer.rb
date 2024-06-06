# frozen_string_literal: true

module Newspaper
  class LabelSynchronizer
    def call(payload)
      Label.synchronize_with_github_by(payload[:repository])
    end
  end
end
