class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.references :repository, null: false, foreign_key: true
      t.string :name,  null: false
      t.string :color, null: false
      t.string :github_id, null: false

      t.timestamps
    end
  end
end
