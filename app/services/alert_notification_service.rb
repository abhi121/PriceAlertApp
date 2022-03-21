class AlertNotificationService


    def initialize(current_price_list)
        @current_price_list = current_price_list
    end

    def update_alerts_and_send_notification
        user_alert_data = get_user_alert_data @current_price
        update_db_entries user_alert_data if user_alert_data
        send_email_notification user_alert_data  if user_alert_data
    end

    private

    def get_user_alert_data price
        #Alert.includes(:user).where("target_price >= ? and status = 0", price).map{|alert| {alert_id: alert.id, user_email: alert.user.email}}
        results = []
        @current_price_list.each do |coin|
            results.push(
                {
                    coin_symbol: coin[:symbol],
                    user_ids: check_target_price_for_coin_in_redis(coin[:symbol], coin[:current_price])
                }
            )
        end
        results
    end

    def update_db_entries user_alert_data
        user_alert_data.each do |data|
            alert = Alert.joins(:user, :coin).where(user_id: data[:user_ids], coins: {symbol: data[:coin_symbol]}).update_all(status: 'triggered')
        end
    end

    def send_email_notification user_data
        user_data.each do |data|
            SendEmailNotificationJob.new.perform(data) if data[:user_ids].present?
        end
        # puts "EMAIL SENT"
        # puts user_data
    end

    def check_target_price_for_coin_in_redis(symbol, price)
        data = REDIS.zrangebyscore("#{symbol}_prices",price,"+inf")
        data = get_user_ids data
        REDIS.zremrangebyscore("#{symbol}_prices",price,"+inf")
        data
    end

    ##if user is allowed to create multiple alerts for same coin

    def get_user_ids alert_ids
        Alert.where(id: alert_ids).pluck(:user_id)
    end


end