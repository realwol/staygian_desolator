class AddChargerToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :user_id, :integer, after: :name
    add_column :vendors, :products_percent, :string
  end
end
