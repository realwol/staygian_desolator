class AddProductTypeNameTranslation < ActiveRecord::Migration
  def change
    add_column :product_types, :product_type_name_translation, :integer, after: :updated_at
  end
end
