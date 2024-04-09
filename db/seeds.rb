# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

repository = Github::Repository.find_by(id: ENV['FJORD_BOOTCAMP_REPOSITORY_ID'])
Repository.create!(
  id: repository.id,
  name: repository.name,
  avatar_url: repository.avatar_url)
