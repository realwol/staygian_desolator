class AddSku1ToProductBasicInfo < ActiveRecord::Migration
  def change
    add_column :product_basic_infos, :sku1, :string, after: :sku
  end
end
