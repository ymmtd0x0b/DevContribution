# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags
    {
      site: 'FjordContribution',
      charset: 'utf-8',
      description: 'チーム開発プラクティスでのGitHub上の取り組みを個人に焦点を当てて可視化できるサービスです。',
      keywords: 'GitHub, Issue, PullRequest, チーム開発, フィヨルドブートキャンプ、FBC',
      reverse: true,
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: "#{request.original_url}/ogp/ogp.jpg", # 本番環境では URL を直書きする
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: "#{request.original_url}/ogp/ogp.jpg" # 本番環境では URL を直書きする
      }
    }
  end
end
