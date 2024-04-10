module Github
  class Repository
    attr_reader :id, :name, :avatar_url

    def initialize(repository)
      @id = repository.id
      @name = repository.full_name
      @avatar_url = repository.owner.avatar_url
    end

    def to_hash
      { id: @id,
        name: @name,
        avatar_url: @avatar_url }
    end

    class << self
      def find_by(id: nil, name: nil)
        return if !!id and !!name

        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
        begin
          repository =
            if id
              client.repo(id.to_i)
            else
              client.repo(name)
            end
          Github::Repository.new(repository)
        rescue
          nil
        end
      end

      def labels(repository, option = { page: 1, per_page: 100 })
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        labels = []
        begin
          begin
            labels_per_page = client.labels(repository.name, option)
          rescue
            return []
          end
          labels.concat labels_per_page
          option[:page] += 1
        end while(labels_per_page.count == option[:per_page])

        labels
      end

      def search_issues(query, option = { page: 1, per_page: 100 })
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        issues = []
        begin
          begin
            issues_per_page = client.search_issues(query, option)
          rescue
            return []
          end
          issues.concat issues_per_page.items
          option[:page] += 1
        end while(issues_per_page.items.count == option[:per_page])

        issues
      end

      def issues_by_number(repository, numbers)
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        issues = []
        numbers.each_slice(50) do |some_numbers| # クエリの文字数制限(256 文字超 (演算子や修飾子は除く))を超えないように何回かに分けて処理を行う
          begin
            issues.concat client.search_issues("repo:#{repository.name} is:issue #{some_numbers.join(' ')}").items
          rescue
            return []
          end
        end

        issues
      end
    end
  end
end
