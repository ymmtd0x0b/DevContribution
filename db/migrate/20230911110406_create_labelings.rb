class CreateLabelings < ActiveRecord::Migration[7.0]
  def change
    create_table :labelings do |t|
      t.bigint :issue_id, null: false
      t.bigint :label_id, null: false

      t.timestamps
    end
    add_index :labelings, %i[issue_id label_id], unique: true
  end
end
