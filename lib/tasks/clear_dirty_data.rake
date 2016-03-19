namespace :clear_dirty_data do
  desc 'clear dup data on translation history'
  task :clear_dup => :environment do
    a = Time.now
    ProductInfoTranslation.all.each do |p|
      aa = Time.now
      p.e_t = p.e_t.gsub("\r",'').gsub("\\r",'') if p.e_t
      p.e_des1 = p.e_des1.gsub("\r",'').gsub("\\r",'') if p.e_des1
      p.e_des2 = p.e_des2.gsub("\r",'').gsub("\\r",'') if p.e_des2
      p.e_des3 = p.e_des3.gsub("\r",'').gsub("\\r",'') if p.e_des3

      p.g_t = p.g_t.gsub("\r",'').gsub("\\r",'') if p.g_t
      p.g_des1 = p.g_des1.gsub("\r",'').gsub("\\r",'') if p.g_des1
      p.g_des2 = p.g_des2.gsub("\r",'').gsub("\\r",'') if p.g_des2
      p.g_des3 = p.g_des3.gsub("\r",'').gsub("\\r",'') if p.g_des3

      p.f_t = p.f_t.gsub("\r",'').gsub("\\r",'') if p.f_t
      p.f_des1 = p.f_des1.gsub("\r",'').gsub("\\r",'') if p.f_des1
      p.f_des2 = p.f_des2.gsub("\r",'').gsub("\\r",'') if p.f_des2
      p.f_des3 = p.f_des3.gsub("\r",'').gsub("\\r",'') if p.f_des3

      p.s_t = p.s_t.gsub("\r",'').gsub("\\r",'') if p.s_t
      p.s_des1 = p.s_des1.gsub("\r",'').gsub("\\r",'') if p.s_des1
      p.s_des2 = p.s_des2.gsub("\r",'').gsub("\\r",'') if p.s_des2
      p.s_des3 = p.s_des3.gsub("\r",'').gsub("\\r",'') if p.s_des3

      p.i_t = p.i_t.gsub("\r",'').gsub("\\r",'') if p.i_t
      p.i_des1 = p.i_des1.gsub("\r",'').gsub("\\r",'') if p.i_des1
      p.i_des2 = p.i_des2.gsub("\r",'').gsub("\\r",'') if p.i_des2
      p.i_des3 = p.i_des3.gsub("\r",'').gsub("\\r",'') if p.i_des3

      p.save
      puts Time.now - aa
    end
    puts Time.now - a
  end

  desc "clear translated dirty data"
  task :go => :environment do
    a = Time.now
    # @infos = ProductInfoTranslation.all
    # @infos.each do |info|
    #   delete_word = " ​​"
    #   if info.g_des2.present? && info.g_des2.index(delete_word).present?
    #     info.g_des2.gsub!(delete_word,'')
    #   end
    #   if info.f_des2.present? && info.f_des2.index(delete_word).present?
    #     info.f_des2.gsub!(delete_word,'')
    #   end
    #   if info.s_des2.present? && info.s_des2.index(delete_word).present?
    #     info.s_des2.gsub!(delete_word,'')
    #   end
    #   if info.i_des2.present? && info.i_des2.index(delete_word).present?
    #     info.i_des2.gsub!(delete_word,'')
    #   end
    #   info.save
    #   puts Time.now - a
    # end
    DescriptionTranslationHistory.all.each do |d|
      aa = Time.now
      d.description = d.description.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.description
      d.china = d.china.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.china
      d.america = d.america.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.america
      d.canada = d.canada.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.canada
      d.british = d.british.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.british
      d.germany = d.germany.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.germany
      d.spain = d.spain.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.spain
      d.italy = d.italy.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.italy
      d.france = d.france.gsub("\r",'').gsub("\n",'').gsub("\\r",'') if d.france
      d.save
      puts Time.now - aa
    end
    puts Time.now - a
  end 
end
