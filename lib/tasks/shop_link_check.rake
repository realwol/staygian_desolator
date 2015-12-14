namespace :shop_link do
  desc 'check_shop_link'
  task :check	=> :environment do
  	# Check table shop_links
    sleep (0..20).to_a.sample
  	shop_link = get_first_shop_link
  	if shop_link
      grasp_link shop_link
      shop_link.update_attributes(status: true)
    else
      puts 'no shop'
  	end
  end
end

def get_first_shop_link
	ShopLink.un_grasp.first
end

def grasp_link shop_link
    links_array = []
    link_hash = {}
    next_uri = ''
    agent = Mechanize.new
    uri = shop_link.link
    redirect_to root_path if uri.blank?

      page = agent.get(uri)
      if page.at('#J_ItemList')
        a = page.at('#J_ItemList').children
      else
        puts page.title
        return
      end

      1.step(a.count - 2,2) do |i|
        link_hash[:address] = "https://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
        product_link_start = link_hash[:address].index('id') + 3
        product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start

        product_link_id = link_hash[:address][product_link_start..product_link_end]
        unless TmallLink.where(product_link_id: product_link_id).first
          link_hash[:address] = "http://detail.tmall.com/item.htm?id=" + product_link_id.to_s
          link_hash[:product_link_id] = product_link_id
          link_hash[:user_id] = shop_link.user_id
          link_hash[:status]  = 'false'
          link_hash[:shop_id]  = (shop_link.shop_id || params[:product][:shop_id])
          links_array << link_hash.dup
        end
      end
      if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
        next_uri = page.at('.ui-page-next').attributes["href"].value
      else
        next_uri = ''
      end

    unless next_uri.blank?
      unless next_uri == ''
        uri = uri[0..(uri.index('?')-1)] + next_uri
        ShopLink.create(shop_id_string: shop_link.shop_id_string, link: uri, user: shop_link.user, status: 'false', shop_id: shop_link.shop_id)
      end
    end
    TmallLink.create(links_array)
end
