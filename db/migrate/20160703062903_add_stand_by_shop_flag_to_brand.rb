class AddStandByShopFlagToBrand < ActiveRecord::Migration
  def change
    add_column :brands, :has_stand_by, :boolean, default: false
  end
end
