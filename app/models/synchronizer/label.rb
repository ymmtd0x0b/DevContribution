# frozen_string_literal: true

module Synchronizer
  class Label
    def call(payload)
      Label.synchronize_with_github_by(payload[:repository])
    end
  end
end
