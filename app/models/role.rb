class Role < ActiveRecord::Base
  has_many :users
  has_many :role_auth_relations
  has_many :auth_lists, through: :role_auth_relations

  scope :valid_role, -> {where(status: 1)}

  def remove_or_add_first_level_auth
    role_first_level_auth_array = self.auth_lists.second_level_auth.map(&:parent_id).uniq
    AuthList.first_level_auth.each do |first_auth|
      if role_first_level_auth_array.index(first_auth.id).present?
        existed_first_level = RoleAuthRelation.find_by(role_id: self.id, auth_list_id: first_auth.id)
        if existed_first_level.present?
          existed_first_level.update_attributes(status: 1) unless existed_first_level.status
        else
          RoleAuthRelation.create(role_id: self.id, auth_list_id: first_auth.id, status: 1)
        end
      else
        not_existed_first_level = RoleAuthRelation.find_by(role_id: self.id, auth_list_id: first_auth.id)
        not_existed_first_level.update_attributes(status: 0) if not_existed_first_level.present?
      end
    end
  end
end
