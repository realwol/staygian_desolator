class AddColumnsToProductBasicInfos < ActiveRecord::Migration
  def change
    add_column :product_basic_infos, :america, :float
    add_column :product_basic_infos, :canada, :float
    add_column :product_basic_infos, :british, :float
    add_column :product_basic_infos, :germany, :float
    add_column :product_basic_infos, :france, :float
    add_column :product_basic_infos, :spain, :float
    add_column :product_basic_infos, :italy, :float
    # add_column :product_basic_infos, :shipment_cost, :float
    # add_column :product_basic_infos, :profit_rate, :float
    # add_column :product_basic_infos, :product_price, :float
    # add_column :product_basic_infos, :america_cash_rate, :float
    # add_column :product_basic_infos, :canada_cash_rate, :float
    # add_column :product_basic_infos, :british_cash_rate, :float
    # add_column :product_basic_infos, :germany_cash_rate, :float
    # add_column :product_basic_infos, :france_cash_rate, :float
    # add_column :product_basic_infos, :spain_cash_rate, :float
    # add_column :product_basic_infos, :italy_cash_rate, :float
  end
end
