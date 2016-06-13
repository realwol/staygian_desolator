class Shop < ActiveRecord::Base
  belongs_to :user
  has_many :brands, through: :brand_shop_relations
  has_many :products
  has_many :tmall_links
  has_many :shop_links
  has_many :brand_shop_relations
  has_many :vendors

  paginates_per 10

  # shop status 1 for valid 0 for invalid

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

  def self.update_shield_type shops, shield_value
    shops.each do |shop|
      shop.products.update_all(shield_type: shield_value)
    end
  end

end
