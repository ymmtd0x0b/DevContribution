class DeliverablesBringer
  def call(options = {})
    bring_assigned_issues_for_github(options[:repository], options[:user])
    bring_reviewed_issues_for_github(options[:repository], options[:user])
    bring_created_issues_for_github(options[:repository], options[:user])
    bring_created_wikis_for_github(options[:repository], options[:user])
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

  ## レビューした Issue
  def bring_reviewed_issues_for_github(repository, user)
    # レビュー依頼されていなくても PR にコメントしたユーザー全てがレビュワーと見做されるので
    # commented_pull_requestes として格納
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    my_commented_pull_requests = client.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.name}")

    # 実際に自分がレビュワーとして携わった PR を抽出
    # 最終的に Approve でなくてもレビューしたと言えるかも...
    reviewed_pull_requests =
      my_commented_pull_requests.items.filter do |pull_request|
        reviews = client.pull_request_reviews(repository.name, pull_request.number)
        reviewers = reviews.map { |review| review.user.login if review.state == 'APPROVED' }.compact
        reviewers.include? user.name
      end

    # Issueをリンクさせる表記法は複数ある
    # ここでは主だった２種類を指定
    auto_link_notation = [/http[a-z.\/:]+\/issues\/\d+/, /#\d+/]

    # 後の処理で正規表現を利用する準備
    regex = Regexp.union(auto_link_notation)

    # レビューした PR の関連 Issue のタイトルを取得
    list_ref_issue_links = reviewed_pull_requests.map do |pull_request|
      # １段目：PRの元になったIssueを貼り付けるセクションを切り出す
      # ２段目：リンクorGitHub固有オートリンク表記されたIssueを抽出
      # ３段目：Issue のタイトルを取得
      pull_request.body.gsub(/\r\n/, '').match(/Issue.*概要/).to_s
                  .scan(Regexp.union(auto_link_notation))
                  .map do |link|
                    issue = client.issue(repository.name, link.match(/\d+$/).to_s)
                  end
                  .uniq { |issue| issue.id }
    end.flatten

    list_ref_issue_links.each do |issue|
      Issue.create!(
        repository_id: repository.id,
        user_id:    user.id,
        title:      issue.title,
        url:        issue.html_url,
        point:      extract_point(issue),
        kind:       Issue.kinds[:reviewed],
        created_at: issue.created_at,
        updated_at: issue.updated_at
      )
    end
  end

  ## 作成した Issue
  def bring_created_issues_for_github(repository, user)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    created_issues = client.search_issues("repo:#{repository.name} is:issue author:#{user.name}")

    created_issues.items.each do |issue|
      Issue.create!(
        repository_id: repository.id,
        user_id:    user.id,
        title:      issue.title,
        url:        issue.html_url,
        point:      extract_point(issue),
        kind:       Issue.kinds[:created],
        created_at: issue.created_at,
        updated_at: issue.updated_at
      )
    end
  end

  ## 作成した Wiki
  def bring_created_wikis_for_github(repository, user)
    Dir.mktmpdir do |dir|
      # 一時ディレクトリのパス ( gitクローンするディレクトリも予め指定しておく )
      path = "#{dir}/#{repository.name}.wiki.git"

      # gitクローン
      Git.clone("https://github.com/#{repository.name}.wiki.git", path)

      # ruby による git 起動
      git = Git.open path

      # 直下の全てのファイルから作成者のユーザーを指定して抽出
      # ※Wikiページは直下のみで複雑な階層構造にはならないっぽい
      # (GitHub の Wikiページの UI にそのような機能が見当たらない)
      my_wikis =
        git.lib.ls_files.filter do |file_name, _|
          # そのファイルの最初のコミッター == 作成者
          git.log.object("#{path}/#{file_name}").last.author.name == user.name
        end

      my_wikis.each do |file_name, _|
        Wiki.create!(
          repository_id: repository.id,
          user_id:    user.id,
          title:      file_name.gsub(/\.md$/, ''),
          created_at: git.log.object("#{path}/#{file_name}").last.author_date,
          updated_at: git.log.object("#{path}/#{file_name}").first.author_date
        )
      end
    end
  end
end
