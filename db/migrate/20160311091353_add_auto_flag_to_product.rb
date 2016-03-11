class AddAutoFlagToProduct < ActiveRecord::Migration
  def change
    add_column :products, :auto_flag, :string
  end
end
