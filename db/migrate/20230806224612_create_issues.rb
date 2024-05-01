class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.references :repository, foreign_key: true, null: false
      t.references :user,       null: false
      t.string :title,          null: false
      t.integer :number,        null: false, unique: true

      t.timestamps
    end
    add_index :issues, %i[repository_id number], unique: true
  end
end
