class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :name
      t.string :father_node
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
