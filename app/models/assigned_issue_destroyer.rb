class AssignedIssueDestroyer
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    assigned_issues_id = user.assigned_issues.where(repository_id: repository.id).pluck(:id)
    return if assigned_issues_id.empty?

    # 自身が担当した Issue は誰かがレビューした Issue でもあるので
    # ReviewTable から参照されているか否かで削除する対象を変える
    if Review.where(issues_id: assigned_issues_id).present?
      # 参照されていれば、 Issue 自体は残してAssignアソシエーションのみを削除する
      user.assigns.where(issues_id: assigned_issues_id).destroy_all
    else
      # 参照されていなければ、Issue 自体が削除候補となる
      # 作成者がこの Issue を参照しない(このサービスやリポジトリを登録していない)場合は削除して問題ない
      not_references_issues_id =
        user.assigned_issues.where(repository_id: repository.id).filter_map do |issue|
          issue.id if issue.user.nil? or issue.user.registrations.find_by(repository_id: repository.id).nil?
        end
      user.assigned_issues.where(id: not_references_issues_id).destroy_all

      # レビューされていない = プルリクは不要なので全て削除する
      user.assigned_pull_requests.where(repository_id: repository.id).destroy_all
    end
  end
end
