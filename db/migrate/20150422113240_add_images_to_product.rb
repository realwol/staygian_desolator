class AddImagesToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :images1, :string
  	add_column :products, :images2, :string
  	add_column :products, :images3, :string
  	add_column :products, :images4, :string
  	add_column :products, :images5, :string
  	add_column :products, :images6, :string
  	add_column :products, :images7, :string
  	add_column :products, :images8, :string
  	add_column :products, :images9, :string
  	add_column :products, :images10, :string
  end
end
