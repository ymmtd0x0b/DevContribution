class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests do |t|
      t.bigint :repository_id, null: false
      t.string :url,           null: false
      t.bigint :user_id,       null: false

      t.timestamps
    end
  end
end
