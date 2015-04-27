class AddDetailTranslationToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :england_detail, :text
  	add_column :products, :germany_detail, :text
  	add_column :products, :france_detail, :text
  	add_column :products, :spain_detail, :text
  	add_column :products, :italy_detail, :text
  end
end
