module Github
  CLIENT = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  class Repository
    class << self
      def get(reposiotry_id)
        CLIENT.repo(reposiotry_id.to_i)
      end

      def unregisted_list(user)
        unregisted_repositories = self.all_collaborated_repository_name_list(user) - user.registed_repositories.pluck(:name)

        unregisted_repositories.uniq.map do |repository_name|
          repository = CLIENT.repo(repository_name)

          { id: repository.id,
            name: repository.full_name,
            description: repository.description,
            avatar: repository.owner.avatar_url }
        end
      end

      private

      def all_collaborated_repository_name_list(user)
        involves_issues = []
        involves_issues.concat Github::Issue.involves(user)
        involves_issues.concat Github::PullRequest.involves(user)

        involves_issues.map{ |issue| issue.repository_url.delete_prefix('https://api.github.com/repos/') }
      end
    end
  end
end


# repository_urls = involves_issues.map(&:repository_url).uniq

# repository_urls
# .filter { |repo_url| user.registed_repos.find_by(name: repo_url.delete_prefix('https://api.github.com/repos/')).nil? }
# .map do |repo_url|
#   repo = CLIENT.repo(repo_url.delete_prefix('https://api.github.com/repos/'))

#   {
#     id: repo.id,
#     name: repo.full_name,
#     description: repo.description,
#     avatar: repo.owner.avatar_url
#   }
# end
