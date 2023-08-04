class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :github_id, null: false, unique: true
      t.string :name,      null: false
      t.string :image_url, null: false

      t.timestamps
    end
  end
end
