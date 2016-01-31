class AddProductDetailTranslationToProducInfoTranslation < ActiveRecord::Migration
  def change
    add_column :product_info_translations, :e_detail, :text, after: :e_t
    add_column :product_info_translations, :g_detail, :text, after: :g_t
    add_column :product_info_translations, :f_detail, :text, after: :f_t
    add_column :product_info_translations, :s_detail, :text, after: :s_t
    add_column :product_info_translations, :i_detail, :text, after: :i_t
  end
end
