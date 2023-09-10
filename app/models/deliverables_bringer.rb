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
    options = { page: 1, per_page: 100 }

    searched_issues_list = []
    begin
      searched_issues = client.search_issues("repo:#{repository.name} is:issue assignee:#{user.name}", **options)
      searched_issues_list << searched_issues.items
      options[:page] += 1
    end while(searched_issues.items.count == options[:per_page])

    assigned_issues =
      searched_issues_list.flatten.map do |issue|
        Issue.new(
          repository_id: repository.id,
          user_id:    user.id,
          issue_id:   issue.id,
          title:      issue.title,
          url:        issue.html_url,
          point:      extract_point(issue),
          kind:       Issue.kinds[:assigned],
          created_at: issue.created_at,
          updated_at: issue.updated_at
        )
      end

    Issue.import assigned_issues
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
    options = { page: 1, per_page: 100 }

    commented_pull_request_list = []
    begin
      commented_pull_requests = client.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.name} -assignee:#{user.name}", **options)
      commented_pull_request_list << commented_pull_requests.items
      options[:page] += 1
    end while(commented_pull_requests.items.count == options[:per_page])

    # 実際に自分がレビュワーとして携わった PR を抽出
    # 最終的に Approve でなくてもレビューしたと言えるかも...
    reviewed_pull_requests =
      commented_pull_request_list.flatten.filter do |pull_request|
        reviews = client.pull_request_reviews(repository.name, pull_request.number)
        reviewers = reviews.map { |review| review.user.login if review.state == 'APPROVED' }
        reviewers.include? user.name
      end

    # Issueをリンクさせる表記法は複数ある
    # ここでは主だった２種類を指定
    auto_link_notation = [/https.+\/issues\/\d+/, /#\d+/]

    # レビューした PR の関連 Issue のタイトルを取得
    reviewed_issue_list =
      reviewed_pull_requests.map do |pull_request|
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

    reviewed_issues =
      reviewed_issue_list.map do |issue|
        Issue.new(
          repository_id: repository.id,
          user_id:    user.id,
          issue_id:   issue.id,
          title:      issue.title,
          url:        issue.html_url,
          point:      extract_point(issue),
          kind:       Issue.kinds[:reviewed],
          created_at: issue.created_at,
          updated_at: issue.updated_at
        )
      end

    Issue.import reviewed_issues
  end

  ## 作成した Issue
  def bring_created_issues_for_github(repository, user)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    options = { page: 1, per_page: 100 }

    created_issue_list = []
    begin
      created_issues = client.search_issues("repo:#{repository.name} is:issue author:#{user.name}", **options)
      created_issue_list << created_issues.items
      options[:page] += 1
    end while(created_issues.items.count == options[:per_page])

    created_issues =
      created_issue_list.flatten.map do |issue|
        Issue.new(
          repository_id: repository.id,
          user_id:    user.id,
          issue_id:   issue.id,
          title:      issue.title,
          url:        issue.html_url,
          point:      extract_point(issue),
          kind:       Issue.kinds[:created],
          created_at: issue.created_at,
          updated_at: issue.updated_at
        )
      end

      Issue.import created_issues
  end

  ## 作成した Wiki
  def bring_created_wikis_for_github(repository, user)
    Dir.mktmpdir do |dir|
      # 一時ディレクトリのパス ( gitクローンするディレクトリも予め指定しておく )
      path = "#{dir}/#{repository.name}.wiki.git"

      # gitクローン
      response = Git.clone("https://github.com/#{repository.name}.wiki.git", path) rescue nil

      # Wikiページが存在するか事前に確かめる術が見つからなかったので
      # gitクローンでエラーが発生したら、Wikiページが存在しないと見做す
      # 例外処理によって nil を返す
      if response.nil?
        return
      end

      # ruby による git 起動
      git = Git.open path

      # 直下の全てのファイルから作成者のユーザーを指定して抽出
      # ※Wikiページは直下のみで複雑な階層構造にはならないっぽい
      # (GitHub の Wikiページの UI にそのような機能が見当たらない)
      my_wikis =
        git.lib.ls_files.map do |file_name, _|
          file_log = git.log.object("#{path}/#{file_name}")

          # そのファイルの最初のコミッター == 作成者
          if file_log.last.author.name == user.name
            { title: file_name.gsub(/\.md$/, ''),
              created_at: file_log.last.author_date,
              updated_at: file_log.first.author_date }
          end
        end

      wikis =
        my_wikis.compact.each do |wiki, _|
          Wiki.new(
            repository_id: repository.id,
            user_id:    user.id,
            title:      wiki[:title],
            created_at: wiki[:created_at],
            updated_at: wiki[:updated_at]
          )
        end

      Wiki.import wikis
    end
  end
end
