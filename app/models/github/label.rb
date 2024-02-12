module Github
  class Label
    class << self
      def create_all(repository, option = { page: 1, per_page: 100 })
        client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])

        labels = []
        begin
          labels_per_page = client.labels(repository.name, option)
          labels_per_page.each do |label|
            labels << {
              repository_id: repository.id,
              id: label.id,
              name: label.name,
              color: label.color
            }
          end
          option[:page] += 1
        end while(labels_per_page.count == option[:per_page])

        ::Label.insert_all(labels) if labels.present?
      end
    end
  end
end
