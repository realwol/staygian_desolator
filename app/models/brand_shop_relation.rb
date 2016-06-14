class BrandShopRelation < ActiveRecord::Base
  belongs_to :brand
  belongs_to :shop

  # relation status: 5=> stand by; 1=> in connection; 2=> forbidden;
end
