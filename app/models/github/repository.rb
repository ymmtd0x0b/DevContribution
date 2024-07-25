# frozen_string_literal: true

module GitHub
  class Repository
    def initialize(id:, name:, avatar_url:)
      @id = id
      @name = name
      @avatar_url = avatar_url
    end

    def to_h
      { id: @id,
        name: @name,
        avatar_url: @avatar_url }
    end

    class << self
      def find_by(id: nil, name: nil)
        client = GitHub::ApiClient.new
        repo = client.repository(id:, name:)
        return nil if repo.nil?

        new(id: repo.id, name: repo.full_name, avatar_url: repo.owner.avatar_url)
      end
    end
  end
end
