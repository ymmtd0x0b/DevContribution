class CreateCollaborations < ActiveRecord::Migration[7.0]
  def change
    create_table :collaborations do |t|
      t.bigint :user_id,       null: false
      t.bigint :repository_id, null: false

      t.timestamps
    end
    add_index :collaborations, %i[user_id repository_id], unique: true
  end
end
