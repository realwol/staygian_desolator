class AddAvatarImagesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :avatar3, :text
    add_column :products, :avatar4, :text
    add_column :products, :avatar5, :text
    add_column :products, :avatar_img_url3, :text
    add_column :products, :avatar_img_url4, :text
    add_column :products, :avatar_img_url5, :text
  end
end
