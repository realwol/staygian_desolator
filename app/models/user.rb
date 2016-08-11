class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # user_product_version: 1(default) for just products himself; 2 for himeself and his teammember; 3 for all the products

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  has_many :shops
  has_many :products
  has_many :shop_links
  has_many :tmall_links
  has_many :search_links
  has_many :variable_translate_histories
  has_many :merchants
  has_many :accounts

  has_many :little_brothers, class_name: 'User', foreign_key: 'manager'
  has_many :team_members, class_name: 'User', foreign_key: 'leader_id'

  belongs_to :big_brother, class_name: 'User', foreign_key: 'manager'
  belongs_to :leader, class_name: 'User', foreign_key: 'leader_id'
  belongs_to :user_role, class_name: 'Role', foreign_key: 'user_role_id'
  belongs_to :department

  default_scope {where(status:true)}
  scope :rank_user, -> {where()}
  scope :not_lzyg, -> {where(status: 1)}
  scope :lzgy_user, -> {where(status: 0)}
  scope :seller, -> {where("leader_id != 1 and id != 1 and user_role_id = 3").not_lzyg}
  scope :group_charger, -> {where("user_role_id = 2 or user_role_id = 9")}

  def self.get_all_group_charger
    User.not_lzyg.group_charger
  end
  def get_his_group_rank
    group_chargers = User.get_all_group_charger
    group_product_array = []
    group_chargers.each do |charger|
      group_product = []
      group_product << charger.id
      members_id = charger.team_members.not_lzyg.pluck(:id)
      all_product_array = Product.updated.onsale.un_shield.where("user_id in (?)", members_id).count
      group_product << all_product_array
      group_product << charger.username
      group_product_array << group_product
    end
    sorted_group_product_array = group_product_array.sort{|x,y| y.second<=> x.second}
    if self.is_dd?
      sorted_group_product_array
    else
      group_product = sorted_group_product_array.find {|line| line.first == self.id }
      group_product << sorted_group_product_array.index(group_product)
      group_product.flatten
    end
  end

  def get_month_group_rank
    group_chargers = User.get_all_group_charger
    group_product_array = []
    group_chargers.each do |charger|
      group_product = []
      group_product << charger.id
      members_id = charger.team_members.not_lzyg.pluck(:id)
      all_product_array = Product.updated.onsale.un_shield.where("user_id in (?) and first_updated_time < '#{Time.now.end_of_day.days_ago(1).strftime('%Y-%m-%d %H:%M:%S')}'
                                      and first_updated_time > '#{Time.now.beginning_of_day.days_ago(30).strftime('%Y-%m-%d %H:%M:%S')}' ", members_id).count
      group_product << all_product_array
      group_product << charger.username
      group_product_array << group_product
    end
    sorted_group_product_array = group_product_array.sort{|x,y| y.second<=> x.second}
    if self.is_dd?
      sorted_group_product_array
    else
      group_product = sorted_group_product_array.find {|line| line.first == self.id }
      group_product << sorted_group_product_array.index(group_product)
      group_product.flatten
    end
  end

  def get_day_group_rank
    group_chargers = User.get_all_group_charger
    group_product_array = []
    group_chargers.each do |charger|
      group_product = []
      group_product << charger.id
      members_id = charger.team_members.not_lzyg.pluck(:id)
      all_product_array = Product.updated.onsale.un_shield.where("user_id in (?) and first_updated_time < '#{Time.now.end_of_day.strftime('%Y-%m-%d %H:%M:%S')}'
                                      and first_updated_time > '#{Time.now.beginning_of_day.strftime('%Y-%m-%d %H:%M:%S')}' ", members_id).count
      group_product << all_product_array
      group_product << charger.username
      group_product_array << group_product
    end
    sorted_group_product_array = group_product_array.sort{|x,y| y.second<=> x.second}
    if self.is_dd?
      sorted_group_product_array
    else
      group_product = sorted_group_product_array.find {|line| line.first == self.id }
      group_product << sorted_group_product_array.index(group_product)
      group_product.flatten
    end
  end


  def self.get_all_rank_users
    User.seller
  end

  def get_rank_users
    get_group_users
  end

  def get_group_users
    if self.is_dd?
      User.not_lzyg.seller
    else
      user_id = self.id
      if self.order_role == 1
        group_members = User.where(leader_id: user_id).not_lzyg.seller
        is_leader = group_members.present?
        if is_leader
          group_members
        else
          User.where(leader_id: self.leader_id).not_lzyg.seller
        end
      else
        []
      end
    end
  end


  def valid_account
    if self.is_dd? || self.is_jj?
      Account.all
    else
      self.accounts
    end
  end

  def self.get_all_leader
    all_leader_id = User.all.pluck(:leader_id).uniq
    User.where("id in (?)", all_leader_id)
  end

  def can_user_see_all?
    self.user_product_version == '3'
  end

  def is_team_member?
    !!self.leader
  end

  def is_leader?
    !!self.team_members.present?
  end

  def is_search_link_valid? link
    !!self.search_links.index(link)
  end

  def has_auth? auth
    !!self.user_role.auth_lists.index(auth)
  end

  def user_first_level_auths
    user_role = self.user_role
    if user_role.present?
      user_role.auth_lists.first_level_auth
    end
  end

  def is_dd?
    self.role == 1
  end

  def is_jj?
    # self.id == 38 && self.email == 'gaojinjin'
    self.role == 2
  end

  # def is_manager?
  #   self.role == 2
  # end

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
      count_children = current_user.team_members
      count_children_array = current_user.team_members.to_a
      all_valid_brothers = count_children.pluck(:id)

      while count_children_array.count > 0
        current_user = count_children_array.pop
        all_valid_brothers = all_valid_brothers << current_user.team_members.pluck(:id)
      end
      all_valid_brothers << current_user.id
      # all_valid_brothers = [current_user.id] + all_valid_brothers
      all_valid_brothers.flatten!
      User.where(id: all_valid_brothers)
    end
  end

  def valid_products
    if self.is_dd? || self.is_hacked? || self.user_product_version == 3
      Product.all
    else
      current_user = self
      count_children = current_user.team_members.to_a
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
      count_children = current_user.team_members.to_a
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
      count_children = current_user.team_members.to_a
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
    self.products.where('first_updated_time > ? and first_updated_time < ?', Time.now.beginning_of_day.days_ago(day), Time.now.end_of_day.days_ago(day)).onsale
  end
end
