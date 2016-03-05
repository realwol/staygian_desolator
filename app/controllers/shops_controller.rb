class ShopsController < ApplicationController
	before_action :set_shop, only: [:edit, :update, :destroy, :shield, :recover, :add_back_up]

	def stop_and_delete
		shop = Shop.find(params[:id])
		shop.products.each do |product|
		  product.variables.destroy_all
		  product.product_info_translations.destroy_all
		  product.destroy
		end
		shop.shop_links.destroy_all
		shop.tmall_links.destroy_all
		shop.destroy
		render json:true
	end

  def search
  	shop_name = params[:shop_name]
  	@search_shops = Shop.where("name like '%#{shop_name}%' ").page(params[:page])
  end

	def edit
	end

	def update
		@shop.update_attributes(name:params[:shop][:name])
		redirect_to get_tmall_links_products_url
	end

	def destroy
		@shop.destroy
		redirect_to get_tmall_links_products_url
	end

	def shield
		@shop.update_attributes(check_status:false)
		redirect_to get_tmall_links_products_url
	end

	def recover
		@shop.update_attributes(check_status:true)
		redirect_to get_tmall_links_products_url
	end

	def add_back_up
		@shop.update_attributes(back_up:params[:back_ups])
		redirect_to get_tmall_links_products_url
	end

	private
	def set_shop
		@shop = Shop.find(params[:id])
	end
end