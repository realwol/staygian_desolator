class ChangeDesc < ActiveRecord::Migration
  def change
    change_column :product_info_translations, :e_des1, :text
    change_column :product_info_translations, :e_des2, :text
    change_column :product_info_translations, :e_des3, :text
    change_column :product_info_translations, :g_des1, :text
    change_column :product_info_translations, :g_des2, :text
    change_column :product_info_translations, :g_des3, :text
    change_column :product_info_translations, :f_des1, :text
    change_column :product_info_translations, :f_des2, :text
    change_column :product_info_translations, :f_des3, :text
    change_column :product_info_translations, :s_des1, :text
    change_column :product_info_translations, :s_des2, :text
    change_column :product_info_translations, :s_des3, :text
    change_column :product_info_translations, :i_des1, :text
    change_column :product_info_translations, :i_des2, :text
    change_column :product_info_translations, :i_des3, :text
  end
end
