class CreateBrandShopRelations < ActiveRecord::Migration
  def change
    create_table :brand_shop_relations do |t|
      t.references :brand, index: true
      t.references :shop, index: true
      t.string :status
      t.string :latest_update_user

      t.timestamps null: false
    end
    add_foreign_key :brand_shop_relations, :brands
    add_foreign_key :brand_shop_relations, :shops
  end
end
