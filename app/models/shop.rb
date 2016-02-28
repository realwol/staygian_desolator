class Shop < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :user
  has_many :products
  has_many :tmall_links
  paginates_per 10

  def self.shop_avaliable? shop_id
    !Shop.where(shop_id: shop_id).last
  end

  def grasp_filter
    self.filter_word.split(' ')
  end
end
