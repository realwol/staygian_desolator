class AddProductAttributeIdToTranslationHistory < ActiveRecord::Migration
  def change
    add_column :attributes_translation_histories, :product_attribute_id, :integer
  end
end
