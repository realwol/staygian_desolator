namespace :ab_test do
  desc 'do the local ab test'
  task :local => :environment do
    puts '*************************'
    puts 'local result'
    puts '*************************'
    exec 'ab -n 1000 -c 100 http://localhost:3000/'
  end

  desc 'do the server db test for one server'
  task :server => :environment do
    puts '*************************'
    puts 'server result'
    puts '*************************'
    exec 'ab -n 1000 -c 100 http://120.25.74.164:3001/'
  end

  desc 'do the server db test for one server'
  task :servers => :environment do
    puts '*************************'
    puts 'servers result'
    puts '*************************'
    exec 'ab -n 1000 -c 100 http://120.25.74.164/variables/variable_translate_list'
  end
end
