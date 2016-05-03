class AddMerchantShipmentCost < ActiveRecord::Migration
  def change
    add_column :merchants, :shipment_cost, :float
  end
end
