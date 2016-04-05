class AddStatusToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :status, :boolean, default: true
    rename_column :merchants, :merchant_secrect_key, :merchant_secret_key
  end
end
