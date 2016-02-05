class AttributesTranslationHistory < ActiveRecord::Base
  belongs_to :product_attribute

  has_one :shipment_weight_relation
end
