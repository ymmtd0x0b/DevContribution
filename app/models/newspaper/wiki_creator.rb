# frozen_string_literal: true

module Newspaper
  class WikiCreator
    def call(user)
      repository = Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])

      # Wiki は API が提供されていない都合上、取得したデータと保存済みデータを
      # 照合できないので、一旦全削除して取得したデータ再登録する
      user.wikis.where(repository_id: repository.id).destroy_all

      wikis = Git::Wiki.created_by(repository, user)
      return nil if wikis.empty?

      Upsert.wiki(wikis)
    end
  end
end
