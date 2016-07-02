require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :user, 'root'
if ENV['env'] == 'test'
  set :domain, '112.74.89.21'
  set :deploy_to, '/root/amazon/tmall'
  set :branch, 'test'
elsif ENV['env'] == 'new'
  set :domain, '120.76.188.226'
  set :deploy_to, '/root/amazon/tmall_new'
  set :branch, 'new'
# else
#   set :domain, '120.25.74.164'
#   set :deploy_to, '/root/work/amazon/tmall'
#   set :branch, 'master'
end
set :repository, 'https://git.oschina.net/gaaraLi/amazon_tmall.git'

set :term_mode, nil
set :keep_releases, '2'

# For system-wide RVM install.
set :rvm_path, '/usr/local/rvm/bin/rvm'
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'config/thin.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/thin.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml', 'secrets.yml' and 'thin.yml'."]

  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    # queue %[
    #   if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
    #     ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
    #   fi
    # ]
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  invoke :stop
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      # queue "thin start -C config/thin.yml"
      # queue "rails s -d -b 0.0.0.0 -p 3001"
      invoke :start
    end

  end
end

desc 'Stop current version on the server.'
task :stop => :environment do
  queue "cd #{deploy_to}/#{current_path}"
  queue 'pwd'
  queue "bundle exec thin stop -C config/thin.yml"
end

desc 'Start current version on the server.'
task :start => :environment do
  queue "cd #{deploy_to}/#{current_path}"
  queue 'pwd'
  queue "bundle exec thin start -C config/thin.yml"
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
