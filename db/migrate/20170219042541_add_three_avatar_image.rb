class AddThreeAvatarImage < ActiveRecord::Migration
  def change
    add_column :products, :avatar6, :string
    add_column :products, :avatar7, :string
    add_column :products, :avatar8, :string
    add_column :products, :avatar_img_url6, :string
    add_column :products, :avatar_img_url7, :string
    add_column :products, :avatar_img_url8, :string
  end
end
