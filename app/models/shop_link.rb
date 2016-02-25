class ShopLink < ActiveRecord::Base
  belongs_to :user

  scope :un_grasp, -> {where(status: 'false')}
  scope :from_search, -> {where(status: 'search')}
  scope :from_shop, -> {where(status: 'shop')}
end
