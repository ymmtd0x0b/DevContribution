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

ActiveRecord::Schema[7.0].define(version: 2023_09_11_110406) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "issues", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "repository_id", null: false
    t.integer "issue_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.integer "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_issues_on_repository_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "labelings", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "label_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_labelings_on_issue_id"
    t.index ["label_id"], name: "index_labelings_on_label_id"
  end

  create_table "labels", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.string "name", null: false
    t.string "color", null: false
    t.string "github_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_labels_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_repositories_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "github_id", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wikis", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "repository_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_wikis_on_repository_id"
    t.index ["user_id"], name: "index_wikis_on_user_id"
  end

  add_foreign_key "issues", "repositories"
  add_foreign_key "issues", "users"
  add_foreign_key "labelings", "issues"
  add_foreign_key "labelings", "labels"
  add_foreign_key "labels", "repositories"
  add_foreign_key "repositories", "users"
  add_foreign_key "wikis", "repositories"
  add_foreign_key "wikis", "users"
end
