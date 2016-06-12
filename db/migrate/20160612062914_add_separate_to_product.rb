class AddSeparateToProduct < ActiveRecord::Migration
  def change
    add_column :products, :is_separate, :boolean, default: 0
  end
end
