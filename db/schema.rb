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

ActiveRecord::Schema[7.0].define(version: 2024_02_11_073228) do
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
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "repository_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "repository_id"], name: "index_contributions_on_user_id_and_repository_id", unique: true
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labelings", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "label_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "label_id"], name: "index_labelings_on_issue_id_and_label_id", unique: true
  end

  create_table "labels", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.string "name", null: false
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pull_requests", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "user_id", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name", null: false
    t.string "avatar", null: false
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
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "pull_request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id", "pull_request_id"], name: "index_solutions_on_issue_id_and_pull_request_id", unique: true
  end

  create_table "users", force: :cascade do |t|
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
  end

end
