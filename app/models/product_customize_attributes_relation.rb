class ProductCustomizeAttributesRelation < ActiveRecord::Base
  belongs_to :product
  belongs_to :attributes_translation_history
end
