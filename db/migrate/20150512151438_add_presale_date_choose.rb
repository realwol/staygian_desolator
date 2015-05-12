class AddPresaleDateChoose < ActiveRecord::Migration
  def change
  	add_column :products, :presale_date, :datetime
  end
end
