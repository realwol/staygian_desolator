class ChangeCashRate < ActiveRecord::Migration
  def change
    change_column :cash_rates, :england, :float
    change_column :cash_rates, :germany, :float
    change_column :cash_rates, :france, :float
    change_column :cash_rates, :spain, :float
    change_column :cash_rates, :italy, :float
    change_column :cash_rates, :amercia, :float
    change_column :cash_rates, :canada, :float
  end
end
