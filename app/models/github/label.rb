module Github
  class Label
    attr_reader :id

    def initialize(repository, label)
      @repository_id = repository.id
      @id = label.id
      @name = label.name
      @color = label.color
    end

    def to_activerecord_attributes
      {
        repository_id: @repository_id,
        id: @id,
        name: @name,
        color: @color
      }
    end

    class << self
      def search(repository)
        labels = Github::Repository.labels(repository)
        labels.map { |label| Github::Label.new(repository, label) }
      end
    end
  end
end
