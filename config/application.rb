require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module BabelHeim
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"
    # 既存データは JST のまま DB に保存されているため、互換性のために :local を維持する。
    # コンテナの TZ も Asia/Tokyo にしておくこと。
    config.active_record.default_timezone = :local
  end
end
