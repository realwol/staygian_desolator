class AuthList < ActiveRecord::Base
  belongs_to :parent_auth, class_name: 'AuthList', foreign_key: 'parent_id'
  belongs_to :role

  scope :first_level_auth, -> {where(status: 1).where(parent_id: nil).order("id")}
  scope :second_level_auth, -> {where(status: 1).where.not(parent_id: nil)}
  scope :valid_auth, -> {where(status: 1)}

  def child_auths
    AuthList.where(status: 1).where(parent_id: self.id)
  end
end
