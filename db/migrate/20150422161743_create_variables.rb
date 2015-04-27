class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :color
      t.string :size
      t.string :price
      t.references :product, index: true
      t.datetime :deleted_at
      t.text :image_url1
      t.text :image_url2
      t.text :image_url3
      t.text :image_url4
      t.text :image_url5
      t.text :image_url6
      t.text :image_url7
      t.text :image_url8
      t.text :image_url9
      t.text :image_url10
      t.string :stock

      t.timestamps null: false
    end
    add_foreign_key :variables, :products
  end
end
