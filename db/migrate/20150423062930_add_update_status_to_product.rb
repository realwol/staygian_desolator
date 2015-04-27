class AddUpdateStatusToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :update_status, :boolean
  end
end
