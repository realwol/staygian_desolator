namespace :ab_test do
  desc 'do the local ab test'
  task :local => :environment do
    puts '*************************'
    puts 'local result'
    puts '*************************'
    exec 'ab -n 1000 -c 100 http://0.0.0.0:5001/'
  end

  desc 'do the server db test'
  task :server => :environment do
    puts '*************************'
    puts 'server result'
    puts '*************************'
    exec 'ab -n 1000 -c 100 http://120.25.74.164:3000/'
  end
end
