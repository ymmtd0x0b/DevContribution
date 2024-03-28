class CreateContributions < ActiveRecord::Migration[7.0]
  def change
    create_table :contributions do |t|
      t.bigint :user_id,       null: false
      t.bigint :repository_id, null: false

      t.timestamps
    end
    add_index :contributions, %i[user_id repository_id], unique: true
  end
end
