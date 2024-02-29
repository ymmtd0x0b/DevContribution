class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.bigint :user_id,  null: false
      t.bigint :issue_id, null: false

      t.timestamps
    end
    add_index :reviews, %i[user_id issue_id], unique: true
  end
end
