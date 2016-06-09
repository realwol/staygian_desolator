class Shop < ActiveRecord::Base
  belongs_to :user
  has_many :products
  has_many :tmall_links
  has_many :shop_links
  has_many :brand_shop_relations

  paginates_per 10

  def self.shop_avaliable? shop_id
    !Shop.where(shop_id: shop_id).last
  end

  def grasp_filter
    if self.filter_word.present?
      self.filter_word.split(' ')
    else
      []
    end
  end
end
