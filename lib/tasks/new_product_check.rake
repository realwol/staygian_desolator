# 2016-03-11 check if there are new products or not, done dev.

namespace :new_product_check do
  desc 'get new product'
  task :check => :environment do
    # shop = get_shop
    a = Time.now
    shops = get_shop
    shops.each do |shop|
      aa = TIme.now
      shop_links = shop.shop_links
      shop_links.each do |shop_link|
        unless check_page shop_link
          break
        end
      end
      puts "===================================="
      puts "#{shop.id} shop number done checking"
      puts "#{Time.now - aa} time costs"
    end
    puts "#{Time.now -a} time costs, all shop done checking"
  end
end

def check_page shop_link
  agent = UserAgents.rand()
  page = Nokogiri::HTML(open( shop_link.link + '&sort=qt', 'User-Agent' => agent, :allow_redirections => :all ))

  # check the current page first
  if page.title == '上天猫，就够了'
    puts '***********************'
    puts '*                     *'
    puts '* behind the wall now *'
    puts '*                     *'
    puts '***********************'
    return
  else
    a = page.at('#J_ItemList')
    if a.nil?
      # no products
    else
      a = a.children
    end
  end
  link_hash = {}
  links_array = []
  next_uri = ''
  1.step(a.count - 2, 2) do |i|
    if a[i].at('a.productImg').nil?
      puts "ad #{i}"
    else
      link_hash[:address] = "https://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
      product_link_start = link_hash[:address].index('id') + 3
      product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start

      product_link_id = link_hash[:address][product_link_start..product_link_end]
      # stop dup product link
      if Product.where(product_link_id: product_link_id).first
        # TmallLink.create(links_array)
        return false
      else
        link_hash[:address] = "http://detail.tmall.com/item.htm?id=" + product_link_id.to_s
        link_hash[:product_link_id] = product_link_id
        link_hash[:user_id] = link.user_id
        link_hash[:status]  = 'false'
        link_hash[:shop_id] = link.shop_id
        link_hash[:auto_update] = link.shop_id
        links_array << link_hash.dup
      end
    end
  end
  TmallLink.create(links_array)
  return true
end

def get_shop
  # check shop link, if one link is done checking, no need to check the rest links in the same shop
  Shop.all
end
