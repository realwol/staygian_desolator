class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def update_auth_status
    auth = AuthList.find(params[:auth_id])
    auth.update_attributes(status: 0)

    @auths = AuthList.valid_auth
    render 'create_auth'
  end

  def update_auth_role_relation
    role_id = params[:role_id]
    @role = Role.find(role_id)
    checked_auth_array = params[:checked_auth_string].split('|')
    # create_array = []
    RoleAuthRelation.where(role_id: role_id).update_all(status: 0)
    checked_auth_array.each do |auth|
      create_hash = {}
      create_hash[:role_id] = role_id
      create_hash[:auth_list_id] = auth
      find_by_create_hash = RoleAuthRelation.find_by(create_hash)
      if find_by_create_hash.present?
        find_by_create_hash.update_attributes(status: 1) unless find_by_create_hash.status
      else
        RoleAuthRelation.create(create_hash)
      end
    end
    # handle first level auth
    @role.remove_or_add_first_level_auth

    @auths = AuthList.second_level_auth
    @auth_relation = []
    @auths.each do |auth|
      @auth_relation << RoleAuthRelation.find_by(role_id: @role.id, auth_list_id: auth.id)
    end
    # render json:true
  end

  def create_auth
    AuthList.create(name: params[:name], parent_id: params[:parent_id], backup: params[:backup], auth_url: params[:auth_url])
    
    @auths = AuthList.valid_auth
  end

  def auth_list_index
    @auths = AuthList.valid_auth
  end

  def index
    @roles = Role.all
  end

  def show
    @auths = AuthList.second_level_auth
    @auth_relation = []
    @auths.each do |auth|
      @auth_relation << RoleAuthRelation.find_by(role_id: @role.id, auth_list_id: auth.id)
    end
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :parent_id)
    end
end
