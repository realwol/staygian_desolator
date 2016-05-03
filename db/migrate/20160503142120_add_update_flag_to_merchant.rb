class AddUpdateFlagToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :update_flag, :boolean
  end
end
