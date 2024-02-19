class LabelRegister
  def call(options = {})
    labels = Github::Label.search(options[:repository])
    return nil if labels.empty?

    Insert.label(labels)
  end
end
