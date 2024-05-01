# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_19_041852) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assigns", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "assignable_type"
    t.bigint "assignable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_id", "user_id"], name: "index_assigns_on_assignable_id_and_user_id", unique: true
    t.index ["assignable_type", "assignable_id"], name: "index_assigns_on_assignable"
    t.index ["user_id"], name: "index_assigns_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "number"], name: "index_issues_on_repository_id_and_number", unique: true
    t.index ["repository_id"], name: "index_issues_on_repository_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "labelings", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "label_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "label_id"], name: "index_labelings_on_issue_id_and_label_id", unique: true
    t.index ["issue_id"], name: "index_labelings_on_issue_id"
    t.index ["label_id"], name: "index_labelings_on_label_id"
  end

  create_table "labels", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.string "name", null: false
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "name"], name: "index_labels_on_repository_id_and_name", unique: true
    t.index ["repository_id"], name: "index_labels_on_repository_id"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.integer "number", null: false
    t.integer "issue_numbers", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "number"], name: "index_pull_requests_on_repository_id_and_number", unique: true
    t.index ["repository_id"], name: "index_pull_requests_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewable_id", "user_id"], name: "index_reviews_on_reviewable_id_and_user_id", unique: true
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.string "name"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  create_table "wikis", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "title"], name: "index_wikis_on_repository_id_and_title", unique: true
    t.index ["repository_id"], name: "index_wikis_on_repository_id"
    t.index ["user_id"], name: "index_wikis_on_user_id"
  end

  add_foreign_key "assigns", "users"
  add_foreign_key "issues", "repositories"
  add_foreign_key "labelings", "issues"
  add_foreign_key "labelings", "labels"
  add_foreign_key "labels", "repositories"
  add_foreign_key "pull_requests", "repositories"
  add_foreign_key "reviews", "users"
  add_foreign_key "wikis", "repositories"
  add_foreign_key "wikis", "users"
end
