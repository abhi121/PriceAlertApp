class Coin < ApplicationRecord

    validates :name, presence: true, uniqueness: true
    validates :symbol, presence: true, uniqueness: true
    validates :current_price, presence: true
    has_many :alerts
  #  enum symbol: ['BTC', 'ETH', 'usdt']
end
