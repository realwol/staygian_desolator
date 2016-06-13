class Department < ActiveRecord::Base
  has_many :users

  def has_user?
    !!self.users.present?
  end
end
