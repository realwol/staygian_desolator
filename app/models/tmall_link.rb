class TmallLink < ActiveRecord::Base
  belongs_to :user

  def self.avaliable? link
  	!all.where(address:link).last
  end

end
