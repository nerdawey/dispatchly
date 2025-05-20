class Api::V1::FailedDispatchesController < ApplicationController
  before_action :set_failed_dispatch, only: [ :show, :retry, :resolve ]

  def index
    @failed_dispatches = FailedDispatch
      .includes(:orders)
      .order(attempted_at: :desc)
      .page(params[:page])
      .per(params[:per_page])

    render json: {
      failed_dispatches: @failed_dispatches.as_json(include: :orders),
      meta: {
        total_pages: @failed_dispatches.total_pages,
        current_page: @failed_dispatches.current_page,
        total_count: @failed_dispatches.total_count
      }
    }
  end

  def show
    # Get dispatch attempts from Redis
    dispatch_attempts = RedisService.get_dispatch_attempts(@failed_dispatch.id)

    render json: {
      failed_dispatch: @failed_dispatch.as_json(include: :orders),
      attempts: dispatch_attempts
    }
  end

  def retry
    begin
      # Get available vehicles
      available_vehicles = Vehicle.available

      if available_vehicles.empty?
        return render json: { error: "No vehicles available" }, status: :unprocessable_entity
      end

      # Try dispatch again
      dispatch_service = DispatchAlgorithmService.new(@failed_dispatch.orders, available_vehicles)
      trips = dispatch_service.call

      # Mark as resolved
      @failed_dispatch.resolve!

      render json: {
        message: "Dispatch retried successfully",
        trips: trips.as_json(include: [ :vehicle, :orders ])
      }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def resolve
    if @failed_dispatch.update(status: "resolved", resolved_at: Time.current)
      render json: { message: "Failed dispatch marked as resolved" }
    else
      render json: { errors: @failed_dispatch.errors }, status: :unprocessable_entity
    end
  end

  def stats
    stats = {
      total: FailedDispatch.count,
      unresolved: FailedDispatch.unresolved.count,
      resolved: FailedDispatch.where.not(resolved_at: nil).count,
      recent: FailedDispatch.recent.count,
      by_reason: FailedDispatch.group(:reason).count
    }

    render json: { stats: stats }
  end

  private

  def set_failed_dispatch
    @failed_dispatch = FailedDispatch.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Failed dispatch not found" }, status: :not_found
  end
end
