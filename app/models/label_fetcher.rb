class LabelFetcher
  def call(options = {})
    repository = options[:repository]
    labels = Github::Label.search(repository)

    labels_id = labels.map(&:id)
    repository.labels.where.not(id: labels_id).destroy_all

    Upsert.label(labels)
  end
end
