class CreateTranslateTokens < ActiveRecord::Migration
  def change
    create_table :translate_tokens do |t|
      t.string :t_id
      t.string :t_type
      t.string :t_status
      t.string :t_method

      t.timestamps null: false
    end
  end
end
