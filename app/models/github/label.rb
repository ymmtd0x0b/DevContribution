# frozen_string_literal: true

module Github
  class Label
    attr_reader :id

    def initialize(repository_id, label_data)
      @id = label_data.id
      @repository_id = repository_id
      @name = label_data.name
      @color = label_data.color
    end

    def to_h
      { id: @id,
        repository_id: @repository_id,
        name: @name,
        color: @color }
    end

    class << self
      def find_by(repository, option = { page: 1, per_page: 100 })
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        labels = []
        loop do
          labels_per_page = client.labels(repository.name, option)
          labels.concat labels_per_page
          option[:page] += 1
          break unless labels_per_page.count == option[:per_page]
        end

        labels.map { |label_data| new(repository.id, label_data) }
      rescue Octokit::Error => e
        log_error(e)
        nil
      end
    end
  end
end
