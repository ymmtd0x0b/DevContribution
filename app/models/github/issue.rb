module Github
  class Issue
    class << self
      def involves(user)
        involves_issues = []
        option = { per_page: 100, page: 1 }

        begin
          issues = CLIENT.search_issues("is:issue involves:#{user.name}", option)
          involves_issues.concat issues.items
          option[:page] += 1
        end while(issues.items.count == 100)

        involves_issues
      end
    end
  end
end
