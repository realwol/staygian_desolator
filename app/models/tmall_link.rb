class TmallLink < ActiveRecord::Base
	acts_as_paranoid
  belongs_to :user
  belongs_to :shop

  def self.avaliable? link
  	!all.where(address:link).last
  end

end
