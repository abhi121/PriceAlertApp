class TriggerAlertJob < ActiveJob::Base
    sidekiq_options :retry => false
    def perform(*args)
        current_price_list = FetchCryptoCurrencyPrice.new.current_price
        AlertNotificationService.new(current_price_list).update_alerts_and_send_notification      
    end
end