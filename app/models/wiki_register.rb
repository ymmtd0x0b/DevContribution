class WikiRegister
  def call(options = {})
    wikis = Git::Wiki.created_by(options[:repository], options[:user])
    return nil if wikis.empty?

    Insert.wiki(wikis)
  end
end
