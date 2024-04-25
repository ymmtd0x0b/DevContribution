# frozen_string_literal: true

module Newspaper
  class LabelCreator
    def call(_)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
      labels = Github::Label.search(repository)

      labels_id = labels.map(&:id)
      repository.labels.where.not(id: labels_id).destroy_all

      Label.bulk_insert(labels)
    end
  end
end
