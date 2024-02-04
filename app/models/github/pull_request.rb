module Github
  class PullRequest
    class << self
      def involves(user)
        involves_pull_requests = []
        option = { per_page: 100, page: 1 }

        begin
          pull_requests = CLIENT.search_issues("is:pr involves:#{user.name}", option)
          involves_pull_requests.concat pull_requests.items
          option[:page] += 1
        end while(pull_requests.items.count == 100)

        involves_pull_requests
      end
    end
  end
end
