class RoleAuthRelation < ActiveRecord::Base
  belongs_to :role, dependent: :destroy
  belongs_to :auth_list

  # default scope big hole
  default_scope {where(status: 1)}
end
