class RenameInCashRate < ActiveRecord::Migration
  def change
    rename_column :cash_rates, :england, :british
    rename_column :cash_rates, :amercia, :america
  end
end
