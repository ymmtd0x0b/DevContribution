class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.bigint :repository_id, null: false
      t.string :name,          null: false
      t.string :color,         null: false

      t.timestamps
    end
  end
end
