class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.references :repository, foreign_key: true, null: false
      t.string :name,           null: false
      t.string :color,          null: false

      t.timestamps
    end
    add_index :labels, %i[repository_id name], unique: true
  end
end
