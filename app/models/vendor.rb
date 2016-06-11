class Vendor < ActiveRecord::Base
  belongs_to :brand
  belongs_to :shop

  scope :valid_vendor, -> {where(status: 1)}
end
