class AddAvatarToProducts < ActiveRecord::Migration
  def change
    add_column :products, :avatar, :text
    add_column :products, :avatar1, :text
    add_column :products, :avatar2, :text

    add_column :products, :avatar_img_url, :text
    add_column :products, :avatar_img_url1, :text
    add_column :products, :avatar_img_url2, :text
  end
end
