class ProductType < ActiveRecord::Base
	acts_as_paranoid
	has_many :products
  has_many :product_attributes
  has_many :childer_product_types, class_name: 'ProductType', foreign_key: 'father_node'

  belongs_to :father_product_type, class_name: 'ProductType', foreign_key: 'father_node'

  def has_product?
    Product.where(product_type_id: self.id).count > 0
  end

  def self.get_final_type
    self.where(is_final_type: true)
  end
end
