class DispatchRetryProcessorJob
  include Sidekiq::Job

  def perform
    FailedDispatch.unresolved.recent.find_each do |failed_dispatch|
      process_failed_dispatch(failed_dispatch)
    end
  end

  private

  def process_failed_dispatch(failed_dispatch)
    # Get the original orders
    orders = failed_dispatch.orders

    # Check if there are any available vehicles now
    available_vehicles = Vehicle.available

    if available_vehicles.any?
      begin
        # Try dispatch again
        DispatchAlgorithmService.new(orders, available_vehicles).call

        # Mark as resolved if successful
        failed_dispatch.resolve!

        # Log success
        Rails.logger.info("Successfully retried dispatch for failed_dispatch_id: #{failed_dispatch.id}")
      rescue StandardError => e
        # Log failure but don't raise to prevent job failure
        Rails.logger.error("Retry failed for dispatch_id: #{failed_dispatch.id}, error: #{e.message}")
      end
    else
      # Update retry count
      failed_dispatch.increment!(:retry_count)

      # If too many retries, mark as permanently failed
      if failed_dispatch.retry_count >= 3
        failed_dispatch.update!(
          status: "permanently_failed",
          resolved_at: Time.current
        )

        # Notify about permanent failure
        NotificationService.new.notify_permanent_dispatch_failure(failed_dispatch)
      end
    end
  end
end
