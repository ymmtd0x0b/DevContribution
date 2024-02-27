class CreatedIssueClear
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    issues_id = user.created_issues.where(repository_id: repository.id).map(&:id)
    return if issues_id.empty?

    reference_issues_id = Reference.where(issue_id: issues_id).pluck(:issue_id)
    not_referenced_issues_id = issues_id - reference_issues_id

    # プルリクから参照されていない Issue なら削除して問題ない
    user.created_issues.where(id: not_referenced_issues_id).destroy_all
  end
end
