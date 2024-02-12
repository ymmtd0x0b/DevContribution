class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.bigint :repository_id, null: false
      t.bigint :user_id,       null: false
      t.string :title,         null: false
      t.string :url,           null: false

      t.timestamps
    end
  end
end
