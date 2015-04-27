class CreateProductInfoTranslations < ActiveRecord::Migration
  def change
    create_table :product_info_translations do |t|
      t.string :e_t
      t.string :e_des1
      t.string :e_des2
      t.string :e_des3
      t.string :g_t
      t.string :g_des1
      t.string :g_des2
      t.string :g_des3
      t.string :f_t
      t.string :f_des1
      t.string :f_des2
      t.string :f_des3
      t.string :s_t
      t.string :s_des1
      t.string :s_des2
      t.string :s_des3
      t.string :i_t
      t.string :i_des1
      t.string :i_des2
      t.string :i_des3
      t.references :product, index: true

      t.timestamps null: false
    end
    add_foreign_key :product_info_translations, :products
  end
end
