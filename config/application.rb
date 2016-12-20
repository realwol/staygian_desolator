require File.expand_path('../boot', __FILE__)

# Export excel or csv
require "csv"

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AmazonTmall
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    Rack::Utils.multipart_part_limit = 0

    config.to_prepare do
      Devise::SessionsController.layout 'login'
    end

    config.middleware.use ActiveRecord::ConnectionAdapters::ConnectionManagement

      # Email config
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.perform_deliveries = true
      config.action_mailer.raise_delivery_errors = true
      config.action_mailer.default charset: "utf-8"

      config.action_mailer.smtp_settings = {
        address:              "smtp.qq.com",
        port:                 465,
        user_name:            "361497565@qq.com",
        password:             "alvluexzwsknbiee",
        authentication:       :plain,
        enable_starttls_auto: true
      }

      config.middleware.use ExceptionNotification::Rack,
        :email => {
          :email_prefix => "[Amazon]",
          :sender_address => %{no-reply <notifier@amazon.com>},
          :exception_recipients => %w{838329367@qq.com 361497565@qq.com realwol@gmail.com},
        }

      # config.action_mailer.smtp_settings = {
      #   address:              "smtp.gmail.com",
      #   port:                 587,
      #   domain:               'gmail.com',
      #   user_name:            "realwol@gmail.com",
      #   password:             "realwol361497565",
      #   authentication:       :plain,
      #   enable_starttls_auto: true
      # }

      # config.middleware.use ExceptionNotification::Rack,
      #   :email => {
      #     :email_prefix => "[Amazon]",
      #     :sender_address => %{no-reply <notifier@amazon.com>},
      #     :exception_recipients => %w{838329367@qq.com 361497565@qq.com realwol@gmail.com},
      #   }

  end
end
