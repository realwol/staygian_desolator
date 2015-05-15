class AddDeletedAtToAllTable < ActiveRecord::Migration
  def change
  	add_column :cash_rates, :deleted_at, :datetime
  	add_column :product_info_translations, :deleted_at, :datetime
  	add_column :shoes_attributes_values, :deleted_at, :datetime
  	add_column :shops, :deleted_at, :datetime
  	add_column :tmall_links, :deleted_at, :datetime
  	add_column :translate_tokens, :deleted_at, :datetime
  	add_column :variable_translate_histories, :deleted_at, :datetime
  end
end
