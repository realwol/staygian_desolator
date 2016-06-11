class CreateAuthLists < ActiveRecord::Migration
  def change
    create_table :auth_lists do |t|
      t.string :name
      t.integer :parent_id
      t.string :backup

      t.timestamps null: false
    end
  end
end
