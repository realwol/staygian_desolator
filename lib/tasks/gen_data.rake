namespace :gen_data do
  desc 'gen new sku'
  task :gen_new_sku_to_product => :environment do
    Product.find_each do |p|
      unless p.sku1.present?
        size = rand(5..8)
        sku1 = (('a'..'z').to_a + (1..9).to_a).shuffle.sample(size).join
        p.update_attributes(sku1: sku1)
        puts p.id
      end
    end
  end
end
