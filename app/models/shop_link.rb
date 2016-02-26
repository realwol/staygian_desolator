class ShopLink < ActiveRecord::Base
  belongs_to :user

  scope :un_grasp, -> {where(status: 'false')}
  scope :from_search, -> {where(link_from: 'search')}
  scope :from_shop, -> {where(link_from: 'shop')}
  scope :need_retry, -> {where(link_retry: true)}
end
