# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


coins_data = [ {name: 'Bitcoin', symbol: 'btc', current_price: 41997},
               {name: 'Ethereum', symbol: 'eth', current_price: 2933},
               {name: 'Tether', symbol: 'usdt', current_price: 1.001}
]

coins_data.each do |coin|
    Coin.create(coin)
    REDIS.set(coin[:symbol], coin[:current_price])
end