class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authenticate_user!
    before_action :set_default_page

    def authenticate_user!
        if user_in_token?
            user = User.find(auth_token[:user_id])
            if user.blank?
              render json: { message: 'User does not exist!' }, status: :unauthorized
              return
            else
              set_current_user user
            end
        else
            render json: { message: 'Not Authenticated' }, status: :unauthorized
        end
        rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { message: 'Not Authenticated' }, status: :unauthorized
    end

    def set_current_user user
        @current_user = user
    end

    

    private

    def set_default_page
        @page = params[:page] || 1
    end

    def http_token
        @http_token ||= if request.headers['Authorization'].present?
                            request.headers['Authorization'].split(' ').last
                        end
    end

    def auth_token
        @auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_in_token?
        http_token && auth_token && auth_token[:user_id].to_i
    end
end
