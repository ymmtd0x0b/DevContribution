# frozen_string_literal: true

module GitHub
  class Label
    attr_reader :id

    def initialize(repository_id:, label: { id:, name:, color: })
      @id = label[:id]
      @repository_id = repository_id
      @name = label[:name]
      @color = label[:color]
    end

    def to_h
      { id: @id,
        repository_id: @repository_id,
        name: @name,
        color: @color }
    end

    class << self
      def registered_by(repository)
        client = GitHub::ApiClient.new
        labels = client.labels(repository.name)
        labels.map { |label| new(repository_id: repository.id, label: { id: label.id, name: label.name, color: label.color }) }
      end
    end
  end
end
