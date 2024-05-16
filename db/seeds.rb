# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# repository = Github::Repository.find_by(name: 'fjordllc/bootcamp')
# Repository.find_and_create_by_octokit(name: 'ymmtd0x0b/for_test2', with_label: true)

repository = Github::Repository.find_by(name: 'ymmtd0x0b/for_test2')
Repository.create!(repository.to_h)

labels = Github::Label.find_by(repository)
Label.upsert_all(labels.map(&:to_h), unique_by: %i[repository_id name]) if labels.any?

# あとで削除する
client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
user = client.user 'ymmtd0x0b'
User.create!(id: user.id, login: user.login)
