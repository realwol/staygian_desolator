class Merchant < ActiveRecord::Base
  belongs_to :user

  has_many :merchant_sku_relations
end
