class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests do |t|
      t.references :repository, foreign_key: true, null: false
      t.integer :number, null: false, unique: true
      t.bigint :issue_numbers, array: true

      t.timestamps
    end
  end
end
