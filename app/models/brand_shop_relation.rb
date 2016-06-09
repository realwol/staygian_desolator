class BrandShopRelation < ActiveRecord::Base
  belongs_to :brand
  belongs_to :shop
end
