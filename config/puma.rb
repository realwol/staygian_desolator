APP_ROOT = '/Users/Leo/work/rails/projects/amazon_tmall'
pidfile "#{APP_ROOT}/tmp/pids/puma.pid"
state_path "#{APP_ROOT}/tmp/sockets/puma.state"
bind "unix://#{APP_ROOT}/tmp/sockets/puma.sock"
activate_control_app "unix://#{APP_ROOT}/tmp/sockets/pumactl.sock"

environment ENV['RAILS_ENV'] || 'production'

daemonize true
workers 2
threads 8,16
