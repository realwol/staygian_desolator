class Reference < ActiveRecord::Base
  scope :using_now, -> {where(is_using:true)}
  scope :grasp_filter, -> {where(key1:'grasp_filter_words')}
end
