class NotificationService
  def notify_dispatch_failure(orders)
    # Log the failure
    Rails.logger.error("Dispatch failure for orders: #{orders.map(&:id).join(', ')}")
    
    # Notify dispatchers
    notify_dispatchers(orders)
    
    # Notify customers if needed
    notify_customers(orders)
  end

  private

  def notify_dispatchers(orders)
    # Get all active dispatchers
    dispatchers = User.dispatchers.active
    
    dispatchers.each do |dispatcher|
      # Send email notification
      DispatcherMailer.dispatch_failure_notification(
        dispatcher,
        orders
      ).deliver_later
      
      # Send in-app notification
      Notification.create!(
        user: dispatcher,
        title: 'Dispatch Failure',
        message: "Failed to assign #{orders.size} orders to vehicles",
        notification_type: 'dispatch_failure',
        metadata: {
          order_ids: orders.map(&:id),
          failure_time: Time.current
        }
      )
    end
  end

  def notify_customers(orders)
    orders.each do |order|
      # Only notify if the order is time-sensitive
      if order.time_sensitive?
        CustomerMailer.delivery_delay_notification(
          order.customer,
          order
        ).deliver_later
      end
    end
  end
end 