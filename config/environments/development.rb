require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  
  config.web_console.whitelisted_ips = '172.18.0.0/16'

  if ENV['REDIS_URL'].present?
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }
    config.action_controller.perform_caching = true
  else
    config.cache_store = :memory_store
    config.action_controller.perform_caching = false
  end

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_job.verbose_enqueue_logs = true
  config.assets.quiet = true

  config.action_controller.raise_on_missing_callback_actions = true
end
