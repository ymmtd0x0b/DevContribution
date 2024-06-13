# frozen_string_literal: true

module Synchronizer
  class Label
    def call(payload)
      repository = payload[:repository]

      labels = Github::Label.registered_by(repository)
      ::Label.synchronize(repository, labels)
    end
  end
end
