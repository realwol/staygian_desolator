
def get_first_shop_link
  ShopLink.un_grasp.first
end

def filter_product product_html, shop_id
  if shop_id.present?
    shop = Shop.find(shop_id)
    product_html.at('a.productShop-name').attributes['href'].value.index(shop.shop_id).nil?
  else
    false
  end
end

def grasp link
  # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  # I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
  agent = UserAgents.rand()
  # agent = Mechanize.new
  page = Nokogiri::HTML(open(link.link, 'User-Agent' => agent, :allow_redirections => :all ))
  
  if page.at('#J_ItemList')
    a = page.at('#J_ItemList').children
  else
    puts 'behind the wall now'
    return
  end

  link_hash = {}
  links_array = []
  next_uri = ''
  1.step(a.count - 2, 2) do |i|
    if a[i].at('a.productImg').nil?
      puts "ad #{i}"
    else
      if filter_product a[i], link.shop_id
        # todo
        puts "not in shop #{i}"
      else
        link_hash[:address] = "https://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
        product_link_start = link_hash[:address].index('id') + 3
        product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start

        product_link_id = link_hash[:address][product_link_start..product_link_end]
        unless TmallLink.where(product_link_id: product_link_id).first
          link_hash[:address] = "http://detail.tmall.com/item.htm?id=" + product_link_id.to_s
          link_hash[:product_link_id] = product_link_id
          link_hash[:user_id] = link.user_id
          link_hash[:status]  = 'false'
          link_hash[:shop_id] = link.shop_id
          links_array << link_hash.dup
        end
      end
    end
  end
  
  # next uri
  if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
    next_uri = page.at('.ui-page-next').attributes["href"].value
  else
    next_uri = ''
  end

  uri = link.link
  unless next_uri.blank?
    unless next_uri == ''
      uri = uri[0..(uri.index('?')-1)] + next_uri
      ShopLink.create(shop_id_string: link.shop_id_string, link: uri, user: link.user, status: 'false', shop_id: link.shop_id)
    end
  end
  TmallLink.create(links_array)
end

namespace :shop_link_auto_check do
  desc 'check shop link automatically'
  task :check => :environment do
    shop_link = get_first_shop_link
    if shop_link.present?
      a = Time.now
      grasp shop_link
      shop_link.update_attributes(status: true)
      puts Time.now - a
    end
  end
end
