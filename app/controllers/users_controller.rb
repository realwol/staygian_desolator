class UsersController < ApplicationController
  before_action :set_user, only: [ :remove_department_user, :show, :edit, :update, :destroy, :change_user_password, :user_setting, :reset_user_pwd, :admin_reset_user_pwd]
  before_action :authenticate_user!

  def replace_user_page
  end

  def replace_user
    need_replace_user_id, target_user_id = params[:need_replace_user], params[:target_user]

    accounts = Account.where(user_id: need_replace_user_id)
    accounts.update_all(user_id: target_user_id) if accounts.present?
    backups = BackupHistory.where(user_id: need_replace_user_id)
    backups.update_all(user_id: target_user_id) if backups.present?
    turnovers = FinancialTurnover.where(creater_id: need_replace_user_id)
    turnovers.update_all(creater_id: target_user_id) if turnovers.present?
    turnovers = FinancialTurnover.where(creater_id: need_replace_user_id)
    turnovers.update_all(creater_id: target_user_id) if turnovers.present?
    merchants = Merchant.where(user_id: need_replace_user_id)
    merchants.update_all(user_id: target_user_id) if merchants.present?
    merchants = Merchant.where(admin_id: need_replace_user_id)
    merchants.update_all(admin_id: target_user_id) if merchants.present?
    # orderitems = OrderItem.where(user_id: need_replace_user_id)
    # orderitems.update_all(user_id: target_user_id) if orderitems.present?
    # orders = Order.where(seller_id: need_replace_user_id)
    # orders.update_all(seller_id: target_user_id) if orders.present?
    products = Product.where(user_id: need_replace_user_id)
    products.update_all(user_id: target_user_id) if products.present?
    search_links = SearchLink.where(user_id: need_replace_user_id)
    search_links.update_all(user_id: target_user_id) if search_links.present?
    shop_links = ShopLink.where(user_id: need_replace_user_id)
    shop_links.update_all(user_id: target_user_id) if shop_links.present?
    shops = Shop.where(user_id: need_replace_user_id)
    shops.update_all(user_id: target_user_id) if shops.present?
    tmall_links = TmallLink.where(user_id: need_replace_user_id)
    tmall_links.update_all(user_id: target_user_id) if tmall_links.present?
    histories = VariableTranslateHistory.where(user_id: need_replace_user_id)
    histories.update_all(user_id: target_user_id) if histories.present?
    redirect_to replace_user_page_user_path
  end

  def remove_department_user
    if @user.present?
      @user.update_attributes(password:'123123ab', status: false )
      @department = @user.department
      @department_users = @department.users
    end
    # render json:true
  end

  def update_responser
    account = Account.find(params[:account_id])
    account.update_attributes(user_id: params[:user_id]) if account.present?
    render json:true
  end

  def user_setting
    
  end

  def create_user_from_depart
    create_user_from_department_param[:manager] = current_user.id
    if params[:update_user_id].present?
      User.find(params[:update_user_id]).update_attributes(create_user_from_department_param)
    else
      User.create(create_user_from_department_param)
    end

    @department = Department.find(params[:department_id])
    @department_users = @department.users
  end

  def user_statistic
    @rank_users = current_user.get_rank_users
    @all_rank_users = User.get_all_rank_users.pluck(:id)
    all_rank_user_string = "(#{@all_rank_users.join(',')})"
    # @today_rank_user_products = Product.updated.onsale.un_shield.yestoday_product.find_by_sql("")
    @today_rank_user_products = Product.find_by_sql("select id, count(id) as user_count, user_id
                                                     from products
                                                     where user_id in #{all_rank_user_string} and update_status = 1 and on_sale = 1 and auto_flag != 13 and shield_type = 0 and
                                                     first_updated_time < '#{Time.now.end_of_day.strftime('%Y-%m-%d %H:%M:%S')}' and first_updated_time > '#{Time.now.beginning_of_day.strftime('%Y-%m-%d %H:%M:%S')}'
                                                     group by user_id order by user_count desc")
    @month_rank_user_products = Product.find_by_sql("select id, count(id) as user_count, user_id
                                                     from products
                                                     where user_id in #{all_rank_user_string} and update_status = 1 and on_sale = 1 and auto_flag != 13 and shield_type = 0 and
                                                     first_updated_time < '#{Time.now.end_of_day.days_ago(1).strftime('%Y-%m-%d %H:%M:%S')}' and first_updated_time > '#{Time.now.beginning_of_day.days_ago(30).strftime('%Y-%m-%d %H:%M:%S')}'
                                                     group by user_id order by user_count desc")
    @all_rank_user_products = Product.find_by_sql("select id, count(id) as user_count, user_id
                                                     from products
                                                     where user_id in #{all_rank_user_string} and update_status = 1 and on_sale = 1 and auto_flag != 13 and shield_type = 0
                                                     group by user_id order by user_count desc")

    flag_product = Product.find_by(product_check_flag: true)
    @current_updated_product_count = Product.where("id < ?", flag_product.id).count
    @all_updated_products_count =  Product.all.count
  end

  def show_little_brothers
    @user = User.find(params[:id])
    @user = @user.role > current_user.role ? @user : current_user
    if @user
      @users = @user.little_brothers
    else
      @users = nil
    end
  end

  def reset_user_pwd
    if @user.valid_password?(params[:old_pwd])
      @user.update_attributes(password: params[:new_pwd])      
      render json: 1
    else
      render json: 0
    end
  end

  def admin_reset_user_pwd
    if params[:new_password].present?
      @user.update_attributes(password: params[:new_password])
      render json: 1
    else
      render json: 0
    end
  end

  def change_user_password
    if params[:new_password] == params[:new_password_confirmation]
      @user.update_attributes(email: params[:new_user_name], password: params[:new_password])
      @flag = 1
    else
      @flag = 2
    end
  end

  def set_selected_user
    if params[:select_type] == '1'
      params[:selected_user_id] = nil if params[:selected_user_id].blank?
    elsif params[:select_type] == '2'
      params[:selected_user_id] = params[:manager_id] if params[:selected_user_id].blank?
      params[:selected_user_id] = current_user.id if params[:selected_user_id].blank?
    end

    if params[:selected_user_id].present?
      @selected_user = User.find(params[:selected_user_id])
      if @selected_user.present?
        session[:selected_user_id] = @selected_user.id
      end
    else
      session[:selected_user_id] = nil
    end
  end

  def create_new_user
    User.create(email: params[:new_user_email], password: params[:new_user_password], manager: current_user.id, role: current_user.role + 1)
    @users = current_user.little_brothers
  end

  def index
      @users = current_user.little_brothers
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params[:user]
    end

    def create_user_from_department_param
      params.permit( :order_role, :email, :username, :password, :leader_id, :user_role_id, :manager, :department_id, :user_product_version)
    end
end
