class CoinsController < ApplicationController
    skip_before_action :authenticate_user!, :only => [:index]
    def index
        @coins = Coin.all ## current_user.alerts
        render json: {data: @coins.page(@page), current_page: @page, total_pages: @coins.page.total_pages, success: 'true'}, status: :ok
    end
end
