class Account < ActiveRecord::Base
  belongs_to :user
  has_many :merchants

  scope :valid, -> {where(status: true)}
end
