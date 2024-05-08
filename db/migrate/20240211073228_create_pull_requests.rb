class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests do |t|
      t.references :repository, foreign_key: true, null: false
      t.integer :number,        null: false, unique: true

      t.timestamps
    end
    add_index :pull_requests, %i[repository_id number], unique: true
  end
end
