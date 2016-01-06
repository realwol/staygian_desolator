class AddChinaToProductTypesHistory < ActiveRecord::Migration
  def change
    add_column :attributes_translation_histories, :china, :string, after: :attribute_name
  end
end
