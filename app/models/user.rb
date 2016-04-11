class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  has_many :shops
  has_many :products
  has_many :shop_links
  has_many :tmall_links
  has_many :variable_translate_histories
  has_many :merchants

  has_many :little_brothers, class_name: 'User', foreign_key: 'manager'

  belongs_to :big_brother, class_name: 'User', foreign_key: 'manager'

  def is_dd?
    self.role == 1
  end

  def is_jj?
    self.id == 38 && self.email == 'gaojinjin'
  end

  def is_manager?
    self.role == 2
  end

  def is_little_brother?
    self.role == 3
  end

  def self.get_all_manager
    self.where(role:2)
  end

  def self.get_all_little_brother
    self.where(role:3)
  end

  def is_hacked?
    self.email == 'wangqiangzu' || self.email == 'kefuzu'
  end

  def valid_brothers
    if self.is_dd?
      User.all
    # elsif self.is_hacked?
    #   User.all
    else
      current_user = self
      count_children = current_user.little_brothers
      count_children_array = current_user.little_brothers.to_a
      all_valid_brothers = count_children.pluck(:id)

      while count_children_array.count > 0
        current_user = count_children_array.pop
        all_valid_brothers = all_valid_brothers << current_user.little_brothers.pluck(:id)
      end
      all_valid_brothers << current_user.id
      # all_valid_brothers = [current_user.id] + all_valid_brothers
      all_valid_brothers.flatten!
      User.where(id: all_valid_brothers)
    end
  end

  def valid_products
    if self.is_dd?
      Product.all
    elsif self.is_hacked?
      Product.all
    else
      current_user = self
      count_children = current_user.little_brothers.to_a
      all_valid_products = current_user.products.pluck(:id)

      while count_children.count > 0
        current_user = count_children.pop
        all_valid_products = all_valid_products << current_user.products.pluck(:id)
      end
      all_valid_products.flatten!
      Product.where(id: all_valid_products)
    end
  end

  def valid_shops
    if self.is_dd?
      Shop.all
    else
      current_user = self
      count_children = current_user.little_brothers.to_a
      all_valid_shops = current_user.shops.pluck(:id)

      while count_children.count > 0
        current_user = count_children.pop
        all_valid_shops = all_valid_shops << current_user.shops.pluck(:id)
      end
      all_valid_shops.flatten!
      Shop.where(id: all_valid_shops)
    end
  end

  def is_shop_valid? shop
    !!self.valid_shops.index(shop)
  end

  def valid_merchants
    if self.is_dd?
      Merchant.all
    else
      current_user = self
      count_children = current_user.little_brothers.to_a
      all_valid_merchants = current_user.merchants.pluck(:id)

      while count_children.count > 0
        current_user = count_children.pop
        all_valid_merchants = all_valid_merchants << current_user.merchants.pluck(:id)
      end
      all_valid_merchants.flatten!
      Merchant.where(id: all_valid_merchants)
    end
  end

  def today_products
    self.products.where('first_updated_time > ? and first_updated_time < ?', Time.now.beginning_of_day, Time.now.end_of_day).onsale
  end

  def seven_day_products day
    if day == 1
      self.products.where('first_updated_time > ? and first_updated_time < ?', Time.now.beginning_of_day.days_ago(day), Time.now.end_of_day).onsale
    else
      self.products.where('first_updated_time > ? and first_updated_time < ?', Time.now.beginning_of_day.days_ago(day), Time.now.end_of_day.days_ago(day)).onsale
    end
  end
end
