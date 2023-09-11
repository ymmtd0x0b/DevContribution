class CreateLabelings < ActiveRecord::Migration[7.0]
  def change
    create_table :labelings do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
