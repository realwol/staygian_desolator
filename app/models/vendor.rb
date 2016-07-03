class Vendor < ActiveRecord::Base
  belongs_to :brand
  belongs_to :shop
  
  paginates_per 100

  scope :valid_vendor, -> {where(status: 1)}
end
