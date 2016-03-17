class ChangeStringToInteger < ActiveRecord::Migration
  def change
    change_column :description_translation_histories, :usage_count, :integer
  end
end
