class AddTitleToVariable < ActiveRecord::Migration
  def change
    add_column :variables, :title_en, :text, after: :id
    add_column :variables, :title_de, :text, after: :id
    add_column :variables, :title_fr, :text, after: :id
    add_column :variables, :title_es, :text, after: :id
    add_column :variables, :title_it, :text, after: :id
    add_column :variables, :title, :text, after: :id
  end
end
