# frozen_string_literal: true

module Github::Label
  class << self
    def search(repository)
      labels = Github::Repository.labels(repository)
      labels.map do |label|
        Label.new(
          repository_id: repository.id,
          id: label.id,
          name: label.name,
          color: label.color
        )
      end
    end
  end
end
