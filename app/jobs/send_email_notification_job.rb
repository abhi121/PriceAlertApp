class SendEmailNotificationJob < ActiveJob::Base
    sidekiq_options :retry => false
    def perform(data)
      coin = data[:coin_symbol]
      emails = User.where(id: data[:user_ids]).pluck(:email)
      AlertNotificationMailer.alert_mail(coin, emails).deliver_later
    end
end