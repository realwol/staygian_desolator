namespace :clear_dirty_data do
  desc "clear translated dirty data"
  task :translate => :environment do
    a = Time.now
    @infos = ProductInfoTranslation.all
    @infos.each do |info|
      delete_word = " ​​"
      if info.g_des2.present? && info.g_des2.index(delete_word).present?
        info.g_des2.gsub!(delete_word,'')
      end
      if info.f_des2.present? && info.f_des2.index(delete_word).present?
        info.f_des2.gsub!(delete_word,'')
      end
      if info.s_des2.present? && info.s_des2.index(delete_word).present?
        info.s_des2.gsub!(delete_word,'')
      end
      if info.i_des2.present? && info.i_des2.index(delete_word).present?
        info.i_des2.gsub!(delete_word,'')
      end
      info.save
      puts Time.now - a
    end
  end 
end
