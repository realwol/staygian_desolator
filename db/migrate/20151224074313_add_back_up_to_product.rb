class AddBackUpToProduct < ActiveRecord::Migration
  def change
    add_column :products, :back_up, :text
  end
end
