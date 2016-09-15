class SearchLink < ActiveRecord::Base
  belongs_to :user

  has_many :products
  has_many :tmall_links

  paginates_per 100

  def self.first_search_link
    SearchLink.where(first_link_status: 1)
  end
end