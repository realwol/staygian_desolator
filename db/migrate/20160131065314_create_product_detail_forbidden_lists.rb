class CreateProductDetailForbiddenLists < ActiveRecord::Migration
  def change
    create_table :product_detail_forbidden_lists do |t|
      t.string :word
      t.string :product_type_id

      t.timestamps null: false
    end
  end
end
