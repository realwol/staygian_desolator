class AttributesTranslationHistory < ActiveRecord::Base
  belongs_to :product_attribute

  has_one :shipment_weight_relation
  has_one :product_customize_attributes_relation
end
