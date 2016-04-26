class AddIndividalDescriptionAndWeight < ActiveRecord::Migration
  def change
    add_column :variables, :weight, :float, after: :price
    add_column :variables, :desc, :text
  end
end
