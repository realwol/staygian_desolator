class AddFirstUpdateTime < ActiveRecord::Migration
  def change
  	add_column :products, :first_updated_time, :datetime
  	remove_column :products, :image_url11
  	remove_column :products, :image_url12
  	remove_column :products, :image_url13
  	remove_column :products, :image_url14
  	remove_column :products, :image_url15
  	remove_column :products, :image_url16
  	remove_column :products, :image_url17
  	remove_column :products, :image_url18
  	remove_column :products, :image_url19
  	remove_column :products, :image_url20
  	remove_column :products, :image_url21
  	remove_column :products, :image_url22
  	remove_column :products, :image_url23
  	remove_column :products, :image_url24
  	remove_column :products, :image_url25
  	remove_column :products, :image_url26
  	remove_column :products, :image_url27
  	remove_column :products, :image_url28
  	remove_column :products, :image_url29
  	remove_column :products, :image_url30
  end
end
