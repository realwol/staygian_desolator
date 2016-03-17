class AddTranslationUsageCount < ActiveRecord::Migration
  def change
    add_column :description_translation_histories, :usage_count, :string
  end
end
