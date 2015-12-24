class AddColumnsToShipmentMethodValues < ActiveRecord::Migration
  def change
    add_column :shipment_method_values, :america_price, :string
    add_column :shipment_method_values, :canada_price, :string
    add_column :shipment_method_values, :british_price, :string
    add_column :shipment_method_values, :germany_price, :string
    add_column :shipment_method_values, :italy_price, :string
    add_column :shipment_method_values, :spain_price, :string
    add_column :shipment_method_values, :france_price, :string
  end
end
