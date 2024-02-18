class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.bigint :user_id,  null: false
      t.bigint :pull_request_id, null: false

      t.timestamps
    end
    add_index :reviews, %i[user_id pull_request_id], unique: true
  end
end
