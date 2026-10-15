# Route 53 のヘルスチェックとデプロイ確認用。DB まで応答することを確認する。
# /up はログに出さない（config.silence_healthcheck_path）。
class HealthController < ActionController::Base
  def show
    ActiveRecord::Base.connection.select_value("SELECT 1")
    render plain: "ok"
  rescue StandardError => e
    Rails.logger.error("health check failed: #{e.class}: #{e.message}")
    render plain: "db unavailable", status: :service_unavailable
  end
end
