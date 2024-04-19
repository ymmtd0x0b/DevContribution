class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.references :repository, foreign_key: true, null: false
      t.bigint :user_id, null: false
      t.string :title, null: false
      t.integer :number, null: false, unique: true

      t.timestamps
    end
  end
end
