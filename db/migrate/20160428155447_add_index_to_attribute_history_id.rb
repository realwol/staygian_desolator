class AddIndexToAttributeHistoryId < ActiveRecord::Migration
  def change
    add_index :attributes_translation_histories, :id
  end
end
