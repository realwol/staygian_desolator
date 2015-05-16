class CreateShopLinks < ActiveRecord::Migration
  def change
    create_table :shop_links do |t|
      t.string :shop_id
      t.text :link
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :shop_links, :users
  end
end
