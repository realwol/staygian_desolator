class AddLockToAttributes < ActiveRecord::Migration
  def change
    add_column :product_attributes, :is_locked, :boolean
  end
end
