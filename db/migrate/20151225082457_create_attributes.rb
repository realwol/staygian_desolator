class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :product_attributes do |t|
      t.string :attribute_name
      t.integer :product_type_id
      t.string :table_name

      t.timestamps null: false
    end
  end
end
