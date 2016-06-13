class AddDefaultToProductAutoFlag < ActiveRecord::Migration
  def change
    change_column :products, :auto_flag, :string, default: '0'
  end
end
