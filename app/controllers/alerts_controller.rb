class AlertsController < ApplicationController
    before_action :load_alert, only: [:update, :destroy]

    def create
        @alert = @current_user.alerts.build(alert_params)
        if @alert.save
            render json: {success: 'true', message: 'Alert Created'}, status: :ok
        else
            render json: {success: 'false', message: @alert.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def index
        if params["status"].present?
            if valid_filter_params?
                cache_key = prepare_cache_key
                alerts = Rails.cache.fetch(cache_key,expires_in: 2.hours) do
                    @current_user.alerts.includes(:coin).send(params["status"]).order('created_at DESC').page(@page).as_json
                end
                render json: {data: alerts, current_page: @page, success: 'true'}, status: :ok
            else
                render json: {message: "Invalid filter value. Allowed Values are # {created, triggered, cancelled}", success: 'false'}, status: :unprocessable_entity
            end
        else   
            cache_key = prepare_cache_key 
            alerts = Rails.cache.fetch(cache_key,expires_in: 2.hours) do
                @current_user.alerts.includes(:coin).order('created_at DESC').page(@page).as_json
            end    
            render json: {data: alerts, current_page: @page, success: 'true'}, status: :ok
        end
    end

    def update
        if @alert.nil?
            render json: {success: 'false', message: 'No Alert found'}, status: :unprocessable_entity
        else
            @alert.update_attributes(alert_update_params)
            render json: {success: 'true', message: 'Alert Updated Successfully'}, status: :unprocessable_entity
        end

    end

    def destroy       
        if @alert.nil?
            render json: {success: 'false', message: 'No Alert found'}, status: :unprocessable_entity
        else
            if @alert.user_id == @current_user.id
                delete_redis_entry @alert
                @alert.destroy
                render json: {success: 'true', message: "Alert destroyed"}, status: :ok
            else
                render json: {success: 'false', message: 'Access Denied'}, status: :unauthorized
            end
        end
    end

    private

    def alert_params
        params.require(:alert).permit(:target_price, :coin_id)
    end

    def alert_update_params
        params.require(:alert).permit(:target_price, :status)
    end

    def prepare_cache_key
        {
            user_id: @current_user.id, 
            latest_alert: @current_user.alerts.maximum(:updated_at), 
            page: @page,
            status: params["status"] || nil
        }
    end

    def valid_filter_params?
        Alert.statuses.keys.include? params["status"]
    end

    def load_alert
        @alert = Alert.includes(:coin).find_by(id: params[:id])
    end

    def delete_redis_entry alert
        REDIS.zrem("#{alert.coin.symbol}_prices",alert.id)
    end 

end
