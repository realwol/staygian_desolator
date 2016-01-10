class ProductAttribute < ActiveRecord::Base
  has_many :attributes_translation_histories, dependent: :destroy

  belongs_to :product_type
end
