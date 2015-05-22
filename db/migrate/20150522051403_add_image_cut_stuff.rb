class AddImageCutStuff < ActiveRecord::Migration
  def change
  	add_column :products, :image_cut_position, :string
  	add_column :products, :image_cut_x, :string
  	add_column :products, :image_cut_y, :string
  end
end
