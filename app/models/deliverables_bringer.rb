class DeliverablesBringer
  def call(options = {})
    bring_assigned_issues_for_github(options[:repository], options[:user])
  end

  private

  ## 担当した Issue
  def bring_assigned_issues_for_github(repository, user)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    assigned_issues = client.search_issues("repo:#{repository.name} is:issue assignee:#{user.name}")

    assigned_issues.items.each do |issue|
      Issue.create!(
        repository_id: repository.id,
        user_id:    user.id,
        title:      issue.title,
        url:        issue.html_url,
        point:      extract_point(issue),
        kind:       Issue.kinds[:assigned],
        created_at: issue.created_at,
        updated_at: issue.updated_at
      )
    end
  end

  def extract_point(issue)
    point_label = issue.labels.find { |label| label[:name].to_i > 0 }
    point_label ? point_label[:name].to_i : 0
  end
end
