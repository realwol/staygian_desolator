# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "/root/web/amazon_tmall/log/cron_log.log"
set :environment, "development"

# grasp product every 30 seconds
every 0.5.minute do
	rake 'grasp:start'
end



# graps product link manually

# every 1.day do
# 	rake 'product_check:pre_sale'
# end

# every 1.minute do
# 	rake 'shop_link:check'
# end
