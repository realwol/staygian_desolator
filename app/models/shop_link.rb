class ShopLink < ActiveRecord::Base
  belongs_to :user

  scope :un_grasp, -> {where(status: 'false')}
end
