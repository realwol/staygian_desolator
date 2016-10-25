class AddRemoveFlagToAccountAndMerchant < ActiveRecord::Migration
  def change
    add_column :accounts, :is_removed, :boolean, default: false
    add_column :merchants, :is_removed, :boolean, default: false
  end
end
