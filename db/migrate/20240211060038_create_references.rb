class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references do |t|
      t.bigint :issue_id       , null: false
      t.bigint :pull_request_id, null: false

      t.timestamps
    end
  end
end
