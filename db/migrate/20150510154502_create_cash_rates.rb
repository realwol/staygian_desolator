class CreateCashRates < ActiveRecord::Migration
  def change
    create_table :cash_rates do |t|
      t.integer :england
      t.integer :germany
      t.integer :france
      t.integer :spain
      t.integer :italy
      t.integer :amercia
      t.integer :canada

      t.timestamps null: false
    end
  end
end
