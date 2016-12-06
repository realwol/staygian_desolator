class Vendor < ActiveRecord::Base
  belongs_to :brand
  belongs_to :shop
  belongs_to :user
  
  paginates_per 100

  scope :valid_vendor, -> {where(status: 1)}
end
