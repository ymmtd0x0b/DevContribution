class Reviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user,         foreign_key: true, null: false
      t.references :pull_request, foreign_key: true, null: false

      t.timestamps
    end
    add_index :reviews, %i[user_id pull_request_id], unique: true
  end
end
