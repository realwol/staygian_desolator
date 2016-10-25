class Account < ActiveRecord::Base
  belongs_to :user
  has_many :merchants

  scope :valid, -> {where(status: true)}
  scope :not_removed, -> {where(is_removed: false)}
  scope :removed, -> {where(is_removed: true)}

  def removed?
    !!self.is_removed
  end
end
