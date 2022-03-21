class Alert < ApplicationRecord

    validates :target_price, presence: true
    validates :target_price, :uniqueness => { scope: [:coin_id, :user_id], message: 'for this coin already exists' }
    belongs_to :user
    belongs_to :coin

    enum status: ['created', 'triggered', 'cancelled']

    after_commit :update_redis_entries 

   
    def as_json(options={})
        super(:except => [:user_id, :coin_id],
            :include => {
                :user => {:only => [:name, :email]},
                :coin => {:only => [:name, :symbol]}
            }
        )
    end

    def update_redis_entries
        if status_changed? and status != 'created'
            REDIS.zrem("#{self.coin.symbol}_prices",self.id)
        elsif 
            REDIS.zrem("#{self.coin.symbol}_prices",self.id)
            REDIS.zadd("#{self.coin.symbol}_prices",self.target_price,self.id)
        else
            REDIS.zadd("#{self.coin.symbol}_prices",self.target_price,self.id)
        end
    end

    
end
