module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: {
          status: "ok",
          service: "payment-orchestration-debugger",
          version: "1.0.0",
          timestamp: Time.current.iso8601
        }, status: :ok
      end
    end
  end
end