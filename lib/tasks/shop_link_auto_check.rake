
def get_first_shop_link
  last_link = ShopLink.where(status: true).order('updated_at').last
  if last_link.present?
    next_link = ShopLink.where('id > ? and shop_id != ? and status = ?', last_link.id, last_link.shop_id, false).first
    if next_link.present?
      next_link
    else
      next_link = ShopLink.un_grasp.from_search.first
    end
  else
    next_link = ShopLink.un_grasp.from_search.first
  end

  if next_link.present?
    next_link
  else
    ShopLink.need_retry.from_search.first
  end
end

def check_old_shop_links
  sleep rand(5..10)
  2.times do
    sleep rand(15..20)
    shop_link = get_first_shop_link
    grasp_shop shop_link if shop_link.present?
  end
end

# all the old shop links check above, new links checked below

def grasp_search_link link
  
  agent = Mechanize.new
  cookie = Mechanize::Cookie.new("cookie1", "UUiHXHY94MibArpt6eDcP5sl%2BJqgt1sbu3Vk8cKBCUw%3D")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)
  # do not change
  cookie = Mechanize::Cookie.new("cookie17", "WvELDNoWjz8c")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("uc1", "cookie15=V32FPkk%2Fw0dUvg%3D%3D&existShop=false")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("tt", "login.tmall.com")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("login", "true")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("_l_g_", "Ug%3D%3D")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)
  # do not change
  cookie = Mechanize::Cookie.new("_med", "dw:1440&dh:900&pw:1440&ph:900&ist:0")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("_nk_", "realwol")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("_tb_token_", "e9bb6de8133e6")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  # do not change
  cookie = Mechanize::Cookie.new("cna", "b91vDALZiDECASQuwCMFpCOV")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("cookie2", "57d6d173757efe20f65a80cbf56a3f3f")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("t", "106c27ff1c8c8e8f5ff5673474978132")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("skt", "35e9c9577a852338")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("res", "scroll%3A1399*5855-client%3A1399*303-offset%3A1399*5855-screen%3A1440*900")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("l", "And3HUkbsXCNRQAV9lJbd-L2h2HBNkua")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("uss", "W8t0uctd5%2FO6dSD1ORW5ekmju%2FNAI9DWNzFKZYAi5%2B0qdVmE0rYpYP1%2Fjw%3D%3D")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  cookie = Mechanize::Cookie.new("isg", "AjEx7BV3zcHAHG5WgbhGQAWxQLsASqWQcEUGohNGJ_gTOlGMW261YN_YKnmm")
  cookie.domain = ".tmall.com"
  cookie.path = "/"
  agent.cookie_jar.add!(cookie)

  # cookie = Mechanize::Cookie.new("unb", "910047907")
  # cookie.domain = ".tmall.com"
  # cookie.path = "/"
  # agent.cookie_jar.add!(cookie)

  page = agent.get link.link

  # ff = Watir::Browser.new
  # ff.goto link.link
  # binding.pry
  # page = Nokogiri::HTML(ff.html)

  if page.title == '上天猫，就够了'
    puts '***********************'
    puts '*                     *'
    puts '* behind the wall now *'
    puts '*                     *'
    puts '***********************'
    return
  else
    a = page.at('#J_ItemList')
    if a.present?
      # next uri
      if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
        next_uri = page.at('.ui-page-next').attributes["href"].value
      else
        next_uri = ''
      end
      uri = link.link
      if !next_uri.blank? && next_uri != ''
        new_url = 'https://list.tmall.com/search_product.htm' + next_uri
        puts new_url
        if SearchLink.where(link: new_url).count > 0
          puts 'old next url'
        else
          if link.father_id.present?
            father_id = link.father_id
          else
            father_id = link.id
          end
          SearchLink.create(father_id: father_id, first_link_status: 0, grasp_shop_id: link.grasp_shop_id, link: new_url, user: link.user, status: true, check_status: false, link_desc: link.link_desc, forbidden_words: link.forbidden_words)
        end
      end
      a = a.children
    end
  end

  # get product links from product page
  link_hash = {}
  links_array = []
  next_uri = ''
  filter_count = 0
  1.step(a.count - 2, 2) do |i|
    if a[i].at('a.productImg').nil?
      puts "ad #{i}"
    else
      unless filter_search_product a[i], link
        # todo
        filter_count = filter_count + 1
        puts "filtered #{filter_count}"
      else
        link_hash[:address] = "https://" + a[i].at('a.productImg').attributes["href"].value[2..-1]
        product_link_start = link_hash[:address].index('id') + 3
        product_link_end = link_hash[:address][product_link_start..-1].index('&') - 1 + product_link_start
        product_link_id = link_hash[:address][product_link_start..product_link_end]

        # stop dup product link
        unless TmallLink.where(product_link_id: product_link_id).first
          link_hash[:address] = "http://detail.tmall.com/item.htm?id=" + product_link_id.to_s
          link_hash[:product_link_id] = product_link_id
          link_hash[:user_id] = link.user_id
          link_hash[:status]  = 'false'
          shop_id = get_shop_id a[i]
          shop = Shop.find_by(shop_id: shop_id)
          link_hash[:shop_id] = shop.try(:id)
          link_hash[:search_link_id] = link.try(:id)
          if shop.status
            link_hash[:product_status] = 5
          else
            link_hash[:product_status] = 1
          end
          links_array << link_hash.dup
        end
      end
    end
  end
  
  # next uri
  # if (page.at('.ui-page-next') && page.at('.ui-page-next').attributes["href"])
  #   next_uri = page.at('.ui-page-next').attributes["href"].value
  # else
  #   next_uri = ''
  # end

  # uri = link.link
  # unless next_uri.blank?
  #   unless next_uri == ''
  #     new_url = 'https://list.tmall.com/search_product.htm' + next_uri
  #     puts new_url
  #     if ShopLink.where(link: new_url).count > 0
  #       puts 'old next url'
  #     else
  #       ShopLink.create(shop_id_string: link.shop_id_string, link: new_url, user: link.user, status: 'false', shop_id: link.shop_id, link_from: link.link_from)
  #     end
  #   end
  # end

  link.update_attributes(check_status: true)
  TmallLink.create(links_array)
end

# use the forbidden words filter the product
def filter_by_words html, link
  filter_words = link.forbidden_words
  if filter_words.present?
    filter_words_array = filter_words.split(' ')
    product_title = html.at('.productTitle').children[1].attributes['title'].value
    filter_words_array.each do |word|
      if product_title.index(word)
        puts "filtered by words"
        return false
      else
        return true
      end
    end
  else
    return true
  end
end

def filter_by_grasp_ids html, link
  grasp_shop_ids = link.grasp_shop_id
  return true unless grasp_shop_ids.present?
  if grasp_shop_ids.present?
    grasp_shop_id_array = grasp_shop_ids.split(' ')
    shop_id = get_shop_id html
    if grasp_shop_id_array.index(shop_id).present?
      return true
    else
      puts "filtered by grasp id"
      return false
    end
  end
end

def filter_by_forbidden_shop html
  shop_id = get_shop_id html
  shop = Shop.find_by(shop_id: shop_id)
  if shop.present?
    if shop.status
      return true
    else
      puts 'filtered by forbidden shop'
      return false
    end
  else
    return true
  end
end

def filter_by_existed_products html
  link_string = html.at('a.productImg').attributes["href"].value[2..-1]
  product_link_start = link_string.index('id') + 3
  product_link_end = link_string[product_link_start..-1].index('&') - 1 + product_link_start
  product_link_id = link_string[product_link_start..product_link_end]
  #TODO the product in delete modle do not count in
  if Product.find_by(product_link_id: product_link_id)
    puts 'filtered by existed product'
    return false
  else
    return true
  end
end

def create_if_new_shop product_html, link
  shop_id = get_shop_id product_html
  unless Shop.find_by(shop_id: shop_id).present?
    shop_name = product_html.at('a.productShop-name').text.try(:strip)
    Shop.create(name: shop_name, shop_from: 'tmall', shop_id: shop_id, user: link.user, status: 1, check_status: 1, filter_word: link.forbidden_words)
  end
end

def get_shop_id html
  href_string = html.at('a.productShop-name').attributes['href'].value
  shop_id_start = href_string.index('user_number_id=')+15
  shop_id_end = href_string[shop_id_start..-1].index('&') - 1

  href_string[shop_id_start..shop_id_start+shop_id_end]
end

def filter_search_product product_html, link
  if product_html.present? && filter_by_words(product_html, link) && filter_by_grasp_ids(product_html, link) && filter_by_forbidden_shop(product_html) && filter_by_existed_products(product_html)
    create_if_new_shop product_html, link
    return true
  else
    return false
  end
end

def check_search_links
  a, b = Time.now, Time.now
  while (b - a) < 1800
    sleep rand(5..10)
    link = get_search_link
    if link.present?
      grasp_search_link link 
      puts link.id
    else
      puts "We are out of links!"
      return
    end
    b = Time.now
  end
end

def get_search_link
  SearchLink.where(check_status: false).first
end


namespace :shop_link_auto_check do
  desc 'check shop link automatically'
  task :check => :environment do
    check_search_links
  end
end
