class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user,       foreign_key: true, null: false
      t.references :reviewable, polymorphic: true

      t.timestamps
    end
    add_index :reviews, %i[reviewable_id user_id], unique: true
  end
end
