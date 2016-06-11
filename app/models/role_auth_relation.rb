class RoleAuthRelation < ActiveRecord::Base
  belongs_to :role
  belongs_to :auth_list

  default_scope {where(status: 1)}
end
