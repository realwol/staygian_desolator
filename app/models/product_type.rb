class ProductType < ActiveRecord::Base
	has_many :products
  has_many :product_attributes
  has_many :shipment_weight_relations
  has_many :children_product_types, class_name: 'ProductType', foreign_key: 'father_node'

  belongs_to :father_product_type, class_name: 'ProductType', foreign_key: 'father_node'
  belongs_to :user

  def has_product?
    Product.where(product_type_id: self.id).count > 0
  end

  def self.get_final_type
    self.where(is_final_type: true)
  end

  def self.first_level_types
    self.where(father_node: 0)
  end

  def has_children?
    self.children_product_types.count > 0
  end

  def all_children
    current_product_type = self
    count_children = current_product_type.children_product_types.to_a
    all_children = []
    
    while count_children.size > 0
      current_product_type = count_children.pop
      current_product_type_children = current_product_type.children_product_types
      if current_product_type_children.count > 0
        count_children << current_product_type_children
        count_children.flatten!
      end
      all_children << current_product_type
    end
    all_children
  end

  def get_chain_name
    chain_names = [self.name]
    current_product_type = self
    while current_product_type.father_product_type.present?
      chain_names << current_product_type.father_product_type.name
      current_product_type = current_product_type.father_product_type
    end
    chain_names.reverse.join('/')
  end

end
