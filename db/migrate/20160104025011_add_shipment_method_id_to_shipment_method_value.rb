class AddShipmentMethodIdToShipmentMethodValue < ActiveRecord::Migration
  def change
    add_column :shipment_method_values, :shipment_method_id, :integer
  end
end
