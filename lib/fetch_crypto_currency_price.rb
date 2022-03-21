require "net/http"
class FetchCryptoCurrencyPrice
   
    def current_price
        get_current_price_from_api
    end

    private


    def get_current_price_from_api
        url = get_url
        current_price_list = make_api_request_and_return_response(url)
        update_db_entries current_price_list
        current_price_list       
    end

    def get_url
        #url = ENV['COINGECKO_API_URL']
        url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=100&page=1&sparkline=false"
        url
    end

    def make_api_request_and_return_response url
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = http.request(request)
        get_current_price_from_response(response)
    end

    def get_current_price_from_response response
        current_price||=JSON.parse(response.body).first(3).map{|coin| {symbol: coin["symbol"], current_price: coin["current_price"]}}
    end
    
    def update_db_entries(coin_data)
       coin_data.each do |coin|
           if REDIS.get(coin[:symbol]) != coin[:current_price]
                #Coin.find_by(symbol: coin[:symbol]).update_column(current_price, coin[:current_price])
                REDIS.set(coin[:symbol],coin[:current_price])
           end
       end
    end   

end