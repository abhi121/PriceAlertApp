class UsersController < ApplicationController
    skip_before_action :authenticate_user!, :only => [:create, :sign_in]


    def sign_in
        @user = User.find_by(email: sign_in_params[:email])
        if @user&.authenticate(sign_in_params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            render json: {auth_token: token, data: @user, success: 'true', message: ''}, status: :ok
        else
            render json: { error: 'unauthorized' }, status: :unauthorized 
        end
    end


    def sign_out
    end

    def create
        @user = User.new(user_params)
        if @user.save and @user.valid?
            token = JsonWebToken.encode(user_id: @user.id)
            render json: {auth_token: token, data: @user, success: 'true', message: ''}, status: :ok
        else
            render json: {data: nil, success: 'false', message: @user.errors}, status: :unprocessable_entity
        end
    end
    
    private

    def user_params
        params.require(:user).permit(:email, :password, :name)
    end

    def sign_in_params
        params.require(:user).permit(:email, :password)
    end

end
