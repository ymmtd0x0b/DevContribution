class CreateWikis < ActiveRecord::Migration[7.0]
  def change
    create_table :wikis do |t|
      t.references :user,       null: false, foreign_key: true
      t.references :repository, null: false, foreign_key: true
      t.string :title,          null: false

      t.timestamps
    end
    add_index :wikis, [:user_id, :repository_id, :title], unique: true
  end
end
