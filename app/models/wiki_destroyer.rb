class WikiDestroyer
  def call(options = {})
    repository = options[:repository]
    user = options[:user]

    # Wiki は API が提供されていない都合上、取得したデータと保存済みデータを
    # 照合することができないので、保存済みデータを一旦全削除して取得したデータ再登録する
    user.created_wikis.where(repository_id: repository.id).destroy_all
  end
end
