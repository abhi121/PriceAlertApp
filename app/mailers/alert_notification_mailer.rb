class AlertNotificationMailer < ActionMailer::Base
  default from: 'sharma.17abhinav@gmail.com'
    def alert_mail(coin, emails) 
        @coin = coin   
        mail(   :to      => emails,
                :subject => "Alert!! Target price reached"
        ) do |format|
          format.html
          end
    end
end