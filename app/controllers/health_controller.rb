class HealthController < ApplicationController
  skip_before_action :authenticate_tenant!, only: [:show]

  def show
    render json: {
      status: 'ok',
      database: ActiveRecord::Base.connection.active?,
      redis: Sidekiq.redis { |r| r.ping == 'PONG' },
      time: Time.current
    }
  rescue => e
    render json: { status: 'error', error: e.message }, status: :service_unavailable
  end
end
