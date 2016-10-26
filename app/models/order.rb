class Order < ActiveRecord::Base
  belongs_to :merchant

  has_many :order_items

  scope :order_in_forty_days, -> {where("created_at > ?", Time.now.days_ago(40))}
end