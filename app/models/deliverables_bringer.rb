class DeliverablesBringer
  def call(options = {})
    bring_repository_labels_for_github(options[:repository])
    bring_assigned_issues_for_github(options[:repository], options[:user])
    bring_reviewed_issues_for_github(options[:repository], options[:user])
    bring_created_issues_for_github(options[:repository], options[:user])
    bring_created_wikis_for_github(options[:repository], options[:user])
  end

  private

  ## リポジトリのラベル
  def bring_repository_labels_for_github(repository)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    options = { page: 1, per_page: 100 }

    labels = []
    begin
      labels_per_page = client.labels(repository.name, **options)
      labels_per_page.each do |label|
        labels << {
          repository_id: repository.id,
          id:    label.id,
          name:  label.name,
          color: label.color
        }
      end
    end while(labels_per_page.count == options[:perpage])

    Label.insert_all(labels) if labels.present?
  end

  ## 担当した Issue
  def bring_assigned_issues_for_github(repository, user)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    options = { page: 1, per_page: 100 }

    assigned_issues_all_pages = []
    begin
      assigned_issues_per_page = client.search_issues("repo:#{repository.name} is:issue assignee:#{user.name}", **options)
      assigned_issues_all_pages.concat assigned_issues_per_page.items
      options[:page] += 1
    end while(assigned_issues_per_page.items.count == options[:per_page])

    assigned_issues = []
    labelings = []
    assigns_list = []
    assigned_issues_all_pages.each do |issue|
      assigned_issues << {
        id: issue.id,
        repository_id: repository.id,
        user_id:    issue.user.id,
        title:      issue.title,
        url:        issue.html_url,
        created_at: issue.created_at,
        updated_at: issue.updated_at
      }

      issue.labels.each do |label|
        labelings << {
          issue_id: issue.id,
          label_id: label.id
        }
      end

      assigns_list << {
        issue_id: issue.id,
        user_id: user.id
      }
    end

    Issue.insert_all(assigned_issues) if assigned_issues.present?
    Labeling.insert_all(labelings) if labelings.present?
    Assign.insert_all(assigns_list, unique_by: %i[user_id issue_id]) if assigns_list.present?
  end

  ## レビューした Issue
  def bring_reviewed_issues_for_github(repository, user)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    options = { page: 1, per_page: 100 }

    reviewed_pull_requests_all_pages = []
    begin
      reviewed_pull_requests_per_page = client.search_issues("repo:#{repository.name} is:pr reviewed-by:#{user.name} review:approved -assignee:#{user.name}", **options)
      reviewed_pull_requests_all_pages.concat reviewed_pull_requests_per_page.items
      options[:page] += 1
    end while(reviewed_pull_requests_per_page.items.count == options[:per_page])

    refs = {}
    reviewed_issue_numbers =
      reviewed_pull_requests_all_pages.map do |pull_request|
        issue_section = pull_request.body.scan(/[Ii]ssue.+概要/m)[0]
        linked_issue_urls = issue_section.scan(/http.+\/issues\/\d+|#\d+/)
        issue_numbers = linked_issue_urls.map { |issue_url| issue_url.slice(/\d+$/) }

        issue_numbers.each do |issue_number|
          refs[issue_number.to_s] = pull_request.html_url
        end

        issue_numbers
      end.flatten.uniq

    reviewed_all_issues = []
    reviewed_issue_numbers.each_slice(100) do |issue_numbers| # クエリの文字数制限(1,0000)を超えないように何回かに分けて処理を行う
      reviewed_issues = client.search_issues("repo:#{repository.name} is:issue #{issue_numbers.join(' ')}")
      reviewed_all_issues.concat reviewed_issues.items
    end

    insert_data = []
    labelings = []
    reviews_list = []
    reviewed_all_issues.each do |issue|
      insert_data << {
        id: issue.id,
        repository_id: repository.id,
        user_id:    issue.user.id,
        title:      issue.title,
        url:        issue.html_url,
        pr_url:     refs[issue.number.to_s],
        created_at: issue.created_at,
        updated_at: issue.updated_at
      }

      issue.labels.each do |label|
        labelings << {
          issue_id: issue.id,
          label_id: label.id
        }
      end

      reviews_list << {
        issue_id: issue.id,
        user_id: user.id
      }
    end

    Issue.insert_all(insert_data) if insert_data.present?
    Labeling.insert_all(labelings) if labelings.present?
    Review.insert_all(reviews_list, unique_by: %i[user_id issue_id]) if reviews_list.present?
  end

  ## 作成した Issue
  def bring_created_issues_for_github(repository, user)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    options = { page: 1, per_page: 100 }

    created_issues_all_pages = []
    begin
      created_issues_per_page = client.search_issues("repo:#{repository.name} is:issue author:#{user.name}", **options)
      created_issues_all_pages.concat created_issues_per_page.items
      options[:page] += 1
    end while(created_issues_per_page.items.count == options[:per_page])

    created_issues = []
    labelings = []
    created_issues_all_pages.each do |issue|
      created_issues << {
        id: issue.id,
        repository_id: repository.id,
        user_id:    issue.user.id,
        title:      issue.title,
        url:        issue.html_url,
        created_at: issue.created_at,
        updated_at: issue.updated_at
      }

      issue.labels.each do |label|
        labelings << {
          issue_id: issue.id,
          label_id: label.id
        }
      end
    end

      Issue.insert_all(created_issues) if created_issues.present?
      Labeling.insert_all(labelings) if labelings.present?
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
        my_wikis.compact.map do |wiki, _|
          {
            repository_id: repository.id,
            user_id:    user.id,
            title:      wiki[:title],
            created_at: wiki[:created_at],
            updated_at: wiki[:updated_at]
          }
        end

      Wiki.insert_all wikis if wikis.present?
    end
  end
end
