class CreateShipmentWeightRelations < ActiveRecord::Migration
  def change
    create_table :shipment_weight_relations do |t|
      t.integer :min_weight
      t.integer :max_weight
      t.integer :attributes_translation_history_id
      t.integer :product_type_id

      t.timestamps null: false
    end
  end
end
