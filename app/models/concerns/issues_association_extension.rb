# frozen_string_literal: true

module IssuesAssociationExtension
  def not_referenced_by_other_users
    sql = <<~"SQL"
      #{not_assigned_by_other_users} AND
      #{not_created_by_other_users}  AND
      #{not_assigned_pull_requests_by_other_users} AND
      #{not_reviewed_pull_requests_by_other_users}
    SQL
    where(sql, owner_id: proxy_association.owner.id)
  end

  private

  def not_assigned_by_other_users
    <<~SQL
      NOT EXISTS (
        SELECT 1
        FROM assigns
        WHERE assigns.assignable_id = issues.id AND assigns.user_id != :owner_id
      )
    SQL
  end

  def not_created_by_other_users
    <<~SQL
      NOT EXISTS (
        SELECT 1
        FROM users
        WHERE issues.user_id = users.id AND issues.user_id != :owner_id
      )
    SQL
  end

  def not_assigned_pull_requests_by_other_users
    <<~SQL
      NOT EXISTS (
        SELECT 1
        FROM resolutions
        INNER JOIN pull_requests ON resolutions.pull_request_id = pull_requests.id
        INNER JOIN assigns ON assignable_type = 'PullRequest' AND assigns.assignable_id = pull_requests.id
        WHERE resolutions.issue_id = issues.id AND assigns.user_id != :owner_id
      )
    SQL
  end

  def not_reviewed_pull_requests_by_other_users
    <<~SQL
      NOT EXISTS (
        SELECT 1
        FROM resolutions
        INNER JOIN pull_requests ON resolutions.pull_request_id = pull_requests.id
        INNER JOIN reviews ON reviews.pull_request_id = pull_requests.id
        WHERE resolutions.issue_id = issues.id AND reviews.user_id != :owner_id
      )
    SQL
  end
end
