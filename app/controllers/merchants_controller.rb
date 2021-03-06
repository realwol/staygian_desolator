class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:edit, :update, :stop_merchant, :destroy, :add_merchant_product, :update_shipment_cost, :get_merchant_skus]

  def account_list
    @accounts = Account.valid
  end

  def create_account
    Account.create(name: params[:name], platform: params[:platform], user: current_user)
    @accounts = Account.valid
  end

  def remove_account
    account = Account.find(params[:id])
    account.destroy
    @accounts = Account.valid
  end

  def set_account_updated
    account = Account.find(params[:id])
    if account.present?
      account.merchants.each do |m|
        m.get_merchant_products.update_all(america_price_change: false, canada_price_change: false, british_price_change: false, germany_price_change: false, france_price_change: false, spain_price_change: false, italy_price_change: false)
      end
    end
    render json: true
  end

  def export_all_account
    aa = Time.now
    accounts = Account.valid
    account_file_names = []
    a, b = 0, 0
    merchant_time_array = []
    accounts.each do |account|
      puts "current account id is #{account.id}"
      folder = "public/export/#{account.name}#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}/"
      # create files
      system("mkdir #{folder}")
      input_filenames = []
      account_merchants = account.merchants
      account_merchants.each do |m|
        aaa = Time.now
        puts "current merchant id is #{m.id}"
        file_name = "#{m.shop_name}.txt"
        input_filenames << file_name
        account_file_names << "#{folder}#{file_name}"
        file = File.open("#{folder}#{file_name}", 'a+')
        file.puts("sku\tprice\tminimum-seller-allowed-price\tmaximum-seller-allowed-price\tquantity\tleadtime-to-ship\t\n")
        country = m.merchant_country_name
        merchant_shipment_cost = m.shipment_cost.to_f
        symbol_count = 0
        m_merchant_products = m.get_merchant_products
        m_merchant_products.each do |p|
          a = a + 1
          # 只更新价格变化的
          if p.read_attribute("#{country}_price_change")
            if p.product_id.present?
              product = Product.find(p.product_id)
              if product.try(:set_stock_zero?)
                b = b + 1
                if symbol_count == 0
                  file.puts("\"#{p.sku}\"\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                  symbol_count = 1
                else
                  file.puts("#{p.sku}\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t0\t\n")
                end
              else
                b = b + 1
                if symbol_count == 0
                  file.puts("\"#{p.sku}\"\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t#{p.inventory}\t\n")
                  symbol_count = 1
                else
                  file.puts("#{p.sku}\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t#{p.inventory}\t\n")
                end
              end
            else
                b = b + 1
                if symbol_count == 0
                  file.puts("\"#{p.sku}\"\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t#{p.inventory}\t\n")
                  symbol_count = 1
                else
                  file.puts("#{p.sku}\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t#{p.inventory}\t\n")
                end
            end
          else
            if symbol_count == 0
              file.puts("\"#{p.sku}\"\t\t\t\t#{p.inventory}\t\n")
              symbol_count = 1
            else
              file.puts("#{p.sku}\t\t\t\t#{p.inventory}\t\n")
            end
          end
        end
        symbol_count = 0
        file.close
        merchant_time_array << Time.now - aaa
      end
    end
    big_folder = "public/export"
    bigzipfile_name = "#{big_folder}/all_accounts-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.zip"
    Zip::File.open(bigzipfile_name, Zip::File::CREATE) do |zipfile|
      account_file_names.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename.gsub('public/export/',''), filename)
      end
    end
    puts "all counts #{a}, actual counts #{b} and cost #{Time.now - aa}"
    merchant_time_array.each{|time| puts time}
    send_file bigzipfile_name, :type=> 'application/text', :x_sendfile=>true and return
  end

  def export_account
    aa = Time.now
    account = Account.find(params[:id])
    folder = "public/export/#{account.name}#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}/"
    # create files
    system("mkdir #{folder}")
    input_filenames = []
    account.merchants.each do |m|
      file_name = "#{m.shop_name}.txt"
      input_filenames << file_name
      file = File.open("#{folder}/#{file_name}", 'a+')
      file.puts("sku\tprice\tminimum-seller-allowed-price\tmaximum-seller-allowed-price\tquantity\tleadtime-to-ship\t\n")
      country = m.merchant_country_name
      merchant_shipment_cost = m.shipment_cost.to_f
      symbol_count = 0
      # all_merchant_products = m.get_merchant_products
      a = 0
      m.get_merchant_products.each do |p|
        a = a + 1
        if p.read_attribute("#{country}_price_change")
          product = Product.find(p.product_id) if p.product_id.present?
          if product.present? && product.set_stock_zero?
            if symbol_count ==0
              file.puts("\"#{p.sku}\"\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t0\t\n")
              symbol_count = 1
            else
              file.puts("#{p.sku}\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t0\t\n")
            end
          else
            if symbol_count ==0
              file.puts("\"#{p.sku}\"\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t#{p.inventory}\t\n")
              symbol_count = 1
            else
              file.puts("#{p.sku}\t#{(p.read_attribute(country).to_i - merchant_shipment_cost).to_i}\t\t\t#{p.inventory}\t\n")
            end
          end
        else
          if symbol_count ==0
            file.puts("\"#{p.sku}\"\t\t\t\t#{p.inventory}\t\n")
            symbol_count = 1
          else
            file.puts("#{p.sku}\t\t\t\t#{p.inventory}\t\n")
          end
        end
      end
      symbol_count = 0
      file.close
    end

    # input_filenames.each do |name|
    #   file = File.open("#{folder}/#{name}", 'a+')
    #   account.merchants.each do |m|
    #     file.puts("a\tb\tc")
    #   end
    #   file.close
    # end

    zipfile_name = "#{folder}#{account.name}-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename, folder + '/' + filename)
      end
      # zipfile.get_output_stream("myFile") { |os| os.write "myFile contains just this" }
    end
    puts "cost #{Time.now - aa}"
    send_file zipfile_name, :type=> 'application/text', :x_sendfile=>true
  end

  def remove_merchant_binding_sku
    merchant = Merchant.find(params[:id])
    merchant.merchant_sku_relations.delete_all
    render json: true
  end

  def get_merchant_skus
    sku_array = @merchant.merchant_sku_relations.pluck(:sku)
    # sku_array = MerchantSkuRelation.where('merchant_id = ?', @merchant.id).select(:sku)
    if sku_array.present?
      skus = sku_array
    end
    render json: skus
  end

  def update_shipment_cost
    unless @merchant.shipment_cost == params[:shipment_cost]
      @merchant.update_attributes(shipment_cost: params[:shipment_cost])
      @merchant.reset_all_sku_price
    end
    render json:true
  end

  def index
    # @merchants = current_user.valid_merchants
    @account = Account.find(params[:account_id])
    @merchants = @account.merchants
  end

  def create
    mws_points = {america: 'https://mws.amazonservices.com', canada: 'https://mws.amazonservices.ca', british: 'https://mws-eu.amazonservices.com', germany: 'https://mws-eu.amazonservices.com', spain: 'https://mws-eu.amazonservices.com', italy: 'https://mws-eu.amazonservices.com', france: 'https://mws-eu.amazonservices.com' }
    params[:merchant_api_address] = mws_points["#{merchant_params[:merchant_country_name]}".to_sym]
    current_user.merchants.create(merchant_params)
    @account = Account.find(merchant_params[:account_id])
    @merchants = @account.merchants  end

  def edit
  end

  def update
    @merchant.update_attributes(merchant_params)
    redirect_to action: :index
  end

  def stop_merchant
    @merchant.update_attributes(status: false)
    render json:true
  end

  def add_merchant_product
    product_sku = params[:product_sku]
    merchant_sku_relation_array = []
    merchant_sku_relation_test_array = []
    a = Time.now
    pre_product = ''
    pre_sku = 'FLAGNIL'
    product_sku_array = product_sku.split("\n")
    product_sku_array.each do |sku|
      sku_part = sku[0..7]
      if pre_product != 'FLAGNIL' && pre_sku == sku_part
        product = pre_product
      else
        product = Product.find_by(sku: sku_part)
        pre_product = product
        pre_sku = sku_part
      end
      # if sku.present?
      #   # unless MerchantSkuRelation.find_by(sku: sku, merchant_id: @merchant.id)
      #     merchant_sku_hash = {}
      #     merchant_sku_hash[:merchant_id] = @merchant.id
      #     merchant_sku_hash[:sku] = sku
      #     merchant_sku_hash[:product_id] = product.try(:id)
      #     merchant_sku_relation_array << merchant_sku_hash
      #   # end
      # end
      create_time = Time.now.strftime("%Y-%m-%d")
      if product.present?
        merchant_sku_relation_test_array << "('#{@merchant.id}', '#{product.try(:id)}', '#{sku}', '#{create_time}', '#{create_time}')"
      else
        merchant_sku_relation_test_array << "('#{@merchant.id}', NULL, '#{sku}', '#{create_time}', '#{create_time}')"
      end
    end
    # MerchantSkuRelation.create(merchant_sku_relation_array)
    abc = merchant_sku_relation_test_array.split(',').flatten
    aaa = "insert into merchant_sku_relations (merchant_id, product_id, sku, created_at, updated_at) values"
    aaab = ''
    abc.each do |bc|
      aaab << bc +','
    end
    aaa = aaa + aaab[0..-2] + ';'
    count = merchant_sku_relation_test_array.count + 1
    connection = ActiveRecord::Base.connection
    connection.execute(aaa)
    puts Time.now - a
    puts count
    render json:true
  end

  def destroy
    if @merchant.present?
      @merchant.destroy
    end
    render json:true
  end

  private
  def merchant_params
    params.permit(:shop_name, :merchant_plantform_name, :merchant_account, :merchant_country_name, :merchant_type, :merchant_aws_access_key_id, :merchant_secret_key, :merchant_seller_id, :merchant_marketplace_id, :merchant_api_address, :account_id)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
