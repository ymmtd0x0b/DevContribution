class ReviewedIssueDestroyer
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    reviewed_issues_id = user.reviewed_issues.where(repository_id: repository.id).pluck(:id)
    return if reviewed_issues_id.empty?

    # 自身がレビューした Issue は誰かが担当した Issue でもあるので
    # AssignTable から参照されているか否かで削除する対象が変わる
    if Assign.where(issue_id: reviewed_issues_id).present?
      # 参照されていれば、 Issue 自体は残してReviewアソシエーションのみを削除する
      user.reviews.where(issue_id: reviewed_issues_id).destroy_all
    else
      # 参照されていなければ、Issue 自体が削除候補となる
      # 作成者がこの Issue を参照しない(このサービスやリポジトリを登録していない)場合は削除して問題ない
      not_referenced_issues_id =
        user.reviewed_issues.where(repository_id: repository.id).filter_map do |issue|
          issue.id if issue.user.nil? or issue.user.collaborations.find_by(repository_id: repository.id).nil?
        end
      user.reviewed_issues.where(id: not_referenced_issues_id).destroy_all

      # 担当されていない = プルリクは不要なので全て削除する
      user.reviewed_pull_requests.where(repository_id: repository.id).destroy_all
    end
  end
end
