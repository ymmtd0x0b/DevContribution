class CreateWikis < ActiveRecord::Migration[7.0]
  def change
    create_table :wikis do |t|
      t.bigint :user_id,       null: false
      t.bigint :repository_id, null: false
      t.string :title,         null: false

      t.timestamps
    end
  end
end
