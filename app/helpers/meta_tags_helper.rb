# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags
    {
      site: 'FjordContribution',
      charset: 'utf-8',
      description: 'チーム開発プラクティスでのGitHub上の取り組みを個人に焦点を当てて可視化できるサービスです。',
      keywords: 'GitHub, Issue, PullRequest, チーム開発, フィヨルドブートキャンプ、FBC'
    }
  end
end
