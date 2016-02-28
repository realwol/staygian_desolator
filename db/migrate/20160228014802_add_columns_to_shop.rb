class AddColumnsToShop < ActiveRecord::Migration
  def change
    add_column :shops, :search_word, :string
    add_column :shops, :filter_word, :string
  end
end
