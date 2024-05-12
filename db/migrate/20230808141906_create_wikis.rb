class CreateWikis < ActiveRecord::Migration[7.0]
  def change
    create_table :wikis do |t|
      t.references :repository, foreign_key: true, null: false
      t.references :user,       foreign_key: true, null: false
      t.string :title,          null: false
      t.string :first_commit_hash, null: false

      t.timestamps
    end
    add_index :wikis, %i[repository_id first_commit_hash], unique: true
  end
end
