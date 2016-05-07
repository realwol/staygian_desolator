namespace :clear_dirty_data do
  desc 'clear variable chinaese symbol'
  task :replace_variable => :environment do
    a = 0
    Variable.all.each do |v|
      v.desc = v.desc.gsub('、',',').gsub('，', ',').gsub('：',':') if v.desc
      v.en = v.en.gsub('、',',').gsub('，', ',').gsub('：',':') if v.en
      v.de = v.de.gsub('、',',').gsub('，', ',').gsub('：',':') if v.de
      v.fr = v.fr.gsub('、',',').gsub('，', ',').gsub('：',':') if v.fr
      v.es = v.es.gsub('、',',').gsub('，', ',').gsub('：',':') if v.es
      v.it = v.it.gsub('、',',').gsub('，', ',').gsub('：',':') if v.it
      v.save
      a = a + 1
      puts a
    end
  end

  desc 'replace chinese symbol'
  task :replace_chinese => :environment do
    a = Time.now
    Product.all.each do |p|
      aa = Time.now
      p.desc1 = p.desc1.gsub('、',',').gsub('，', ',').gsub('：',':') if p.desc1
      p.desc2 = p.desc2.gsub('、',',').gsub('，', ',').gsub('：',':') if p.desc2
      p.desc3 = p.desc3.gsub('、',',').gsub('，', ',').gsub('：',':') if p.desc3
      p.save
      puts Time.now - aa
    end

    ProductInfoTranslation.all.each do |p|
      aa = Time.now
      p.e_t = p.e_t.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.e_t
      p.g_t = p.g_t.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.g_t
      p.f_t = p.f_t.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.f_t
      p.s_t = p.s_t.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.s_t
      p.i_t = p.i_t.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.i_t

      p.e_detail = p.e_detail.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.e_detail
      p.e_des1 = p.e_des1.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.e_des1
      p.e_des2 = p.e_des2.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.e_des2
      p.e_des3 = p.e_des3.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.e_des3

      p.g_detail = p.g_detail.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.g_detail
      p.g_des1 = p.g_des1.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.g_des1
      p.g_des2 = p.g_des2.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.g_des2
      p.g_des3 = p.g_des3.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.g_des3

      p.f_detail = p.f_detail.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.f_detail
      p.f_des1 = p.f_des1.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.f_des1
      p.f_des2 = p.f_des2.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.f_des2
      p.f_des3 = p.f_des3.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.f_des3

      p.s_detail = p.s_detail.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.s_detail
      p.s_des1 = p.s_des1.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.s_des1
      p.s_des2 = p.s_des2.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.s_des2
      p.s_des3 = p.s_des3.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.s_des3

      p.i_detail = p.i_detail.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.i_detail
      p.i_des1 = p.i_des1.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.i_des1
      p.i_des2 = p.i_des2.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.i_des2
      p.i_des3 = p.i_des3.gsub('、', ',').gsub('，', ',').gsub('：',':') if p.i_des3

      p.save
      puts Time.now - aa
    end

    DescriptionTranslationHistory.all.each do |d|
      aa = Time.now
      d.description = d.description.gsub('、',',').gsub('，', ',').gsub('：',':') if d.description
      d.china = d.china.gsub('、',',').gsub('，', ',').gsub('：',':') if d.china
      d.america = d.america.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.america
      d.canada = d.canada.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.canada
      d.british = d.british.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.british
      d.germany = d.germany.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.germany
      d.spain = d.spain.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.spain
      d.italy = d.italy.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.italy
      d.france = d.france.gsub('、', ',').gsub('，', ',').gsub('：',':') if d.france
      d.save
      puts Time.now - aa
    end

    puts Time.now - a
  end

  desc 'replace chinese bracket'
  task :replace_bracket => :environment do
    a = Time.now
    ProductInfoTranslation.all.each do |p|
      aa = Time.now
      p.e_t = p.e_t.gsub('（', '(').gsub('）', ')') if p.e_t
      p.g_t = p.g_t.gsub('（', '(').gsub('）', ')') if p.g_t
      p.f_t = p.f_t.gsub('（', '(').gsub('）', ')') if p.f_t
      p.s_t = p.s_t.gsub('（', '(').gsub('）', ')') if p.s_t
      p.i_t = p.i_t.gsub('（', '(').gsub('）', ')') if p.i_t
      p.save
      puts Time.now - aa
    end
    puts Time.now - a
  end

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
