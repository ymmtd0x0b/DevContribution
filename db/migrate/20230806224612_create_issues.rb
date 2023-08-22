class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.references :user,       null: false, foreign_key: true
      t.references :repository, null: false, foreign_key: true
      t.integer :issue_id,      null: false
      t.string :title,          null: false
      t.string :url,            null: false
      t.integer :point,         null: false, default: 0
      t.integer :kind,          null: false

      t.timestamps
    end
  end
end
