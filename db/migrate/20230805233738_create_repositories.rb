class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name,     null: false

      t.timestamps
    end
    add_index :repositories, [:user_id, :name], unique: true
  end
end
