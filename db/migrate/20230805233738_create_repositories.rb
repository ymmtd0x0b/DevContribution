class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.string :name,       null: false
      t.string :avatar_url, null: false

      t.timestamps
    end
  end
end
