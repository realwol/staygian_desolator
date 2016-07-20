class AuthList < ActiveRecord::Base
  belongs_to :parent_auth, class_name: 'AuthList', foreign_key: 'parent_id'
  belongs_to :role

  scope :first_level_auth, -> {where(status: 1).where(parent_id: nil).where(auth_from: 0).order("id")}
  scope :order_first_level_auth, -> {where(status: 1).where(parent_id: nil).where(auth_from: 1).order("id")}
  scope :second_level_auth, -> {where(status: 1).where.not(parent_id: nil)}
  scope :order_second_level_auth, -> {where(status: 1).where(auth_from: 1).where.not(parent_id: nil)}
  scope :valid_auth, -> {where(status: 1)}
  scope :from_amazon, -> {where(auth_from: 0)}
  scope :from_order, -> {where(auth_from: 1)}
  # default_scope {where(auth_from: 0)}

  def child_auths
    AuthList.where(status: 1).where(parent_id: self.id)
  end
end
