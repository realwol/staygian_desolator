class ShipmentWeightRelation < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :attributes_translation_history
end
