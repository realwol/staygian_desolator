class Shop < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :user
  paginates_per 10

  def self.shop_avaliable? shop_id
  	!!Shop.where(shop_id: shop_id).last
  end
end
