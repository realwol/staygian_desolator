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

  has_many :little_brothers, class_name: 'User', foreign_key: 'manager'

  belongs_to :big_brother, class_name: 'User', foreign_key: 'manager'

  def is_dd?
    self.role == 1
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

  def valid_products
    if self.is_dd?
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
end
