class CreateAssigns < ActiveRecord::Migration[7.0]
  def change
    create_table :assigns do |t|
      t.bigint :user_id,  null: false
      t.references :assignable, polymorphic: true

      t.timestamps
    end
    add_index :assigns, %i[assignable_id user_id], unique: true
  end
end
