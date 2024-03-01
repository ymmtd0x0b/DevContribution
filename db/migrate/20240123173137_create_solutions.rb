class CreateSolutions < ActiveRecord::Migration[7.0]
  def change
    create_table :solutions do |t|
      t.bigint :user_id,       null: false
      t.bigint :repository_id, null: false

      t.timestamps
    end
    add_index :solutions, %i[user_id repository_id], unique: true
  end
end
