class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references do |t|
      t.bigint :issue_id       , null: false
      t.bigint :pull_request_id, null: false

      t.timestamps
    end
    add_index :references, %i[issue_id pull_request_id], unique: true
  end
end
