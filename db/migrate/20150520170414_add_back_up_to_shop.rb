class AddBackUpToShop < ActiveRecord::Migration
  def change
  	add_column :shops, :back_up, :text
  end
end
