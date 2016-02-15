class CreateProductCustomizeAttributesRelations < ActiveRecord::Migration
  def change
    create_table :product_customize_attributes_relations do |t|
      t.integer :product_type_id
      t.integer :product_id
      t.string :attribute_name
      t.integer :attributes_translation_history_id

      t.timestamps null: false
    end
  end
end
