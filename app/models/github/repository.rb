# frozen_string_literal: true

module Github
  class Repository
    def initialize(id:, name:, url:, avatar_url:)
      @id = id
      @name = name
      @url = url
      @avatar_url = avatar_url
    end

    def to_h
      { id: @id,
        name: @name,
        url: @url,
        avatar_url: @avatar_url }
    end

    class << self
      def find_by(id: nil, name: nil)
        client = Github::ApiClient.new
        repo = client.repository(id:, name:)
        return nil if repo.nil?

        new(id: repo.id, name: repo.full_name, url: repo.html_url, avatar_url: repo.owner.avatar_url)
      end
    end
  end
end
