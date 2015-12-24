class CreateShipmentMethodValues < ActiveRecord::Migration
  def change
    create_table :shipment_method_values do |t|
      t.string :region
      t.string :weight
      t.float :price

      t.timestamps null: false
    end
  end
end
