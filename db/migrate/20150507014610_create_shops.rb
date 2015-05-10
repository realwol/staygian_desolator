class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.references :user, index: true
      t.boolean :status, default: true

      t.timestamps null: false
    end
    add_foreign_key :shops, :users
  end
end
