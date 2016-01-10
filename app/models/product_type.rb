class ProductType < ActiveRecord::Base
	acts_as_paranoid
	has_many :products
  has_many :childer_product_types, class_name: 'ProductType', foreign_key: 'father_node'

  belongs_to :father_product_type, class_name: 'ProductType', foreign_key: 'father_node'
end
