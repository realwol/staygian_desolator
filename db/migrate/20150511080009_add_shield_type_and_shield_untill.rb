class AddShieldTypeAndShieldUntill < ActiveRecord::Migration
  def change
  	add_column :products, :shield_type, :string, default: 0
  	add_column :products, :shield_untill, :datetime
  end
end
