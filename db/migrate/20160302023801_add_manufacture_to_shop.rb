class AddManufactureToShop < ActiveRecord::Migration
  def change
    add_column :shops, :manufacture, :string
  end
end
