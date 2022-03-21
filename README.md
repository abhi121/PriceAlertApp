# README

Ruby version: 2.7.4
Rails version: 5.2.7

DB COMMANDS:
rails db:create
rails db:migrate
rails db:seed

RUN SERVER:
rails s 


RUN SIDEKIQ: (redis required)
bundle exec sidekiq



APIS:
USER:

    POST: /sign_up
    {
	"user" :{		
		"name": "troy",
		"email": "abc@gmail.com",
		"password": "password"
		
	    }
    }

    POST: /sign_in
    {
	"user": {
		"email": "abc@gmail.com",
		"password": "password"
	    }
    }


COINS:      ##use rails db:seed command to generate this data
     GET: /coins
     output:
     {
	"data": [
		{
			"id": 1,
			"name": "Bitcoin",
			"symbol": "btc",
			"current_price": 41997.0,
			"created_at": "2022-03-20T19:02:13.526Z",
			"updated_at": "2022-03-20T19:02:13.526Z"
		},
		{
			"id": 2,
			"name": "Ethereum",
			"symbol": "eth",
			"current_price": 2933.0,
			"created_at": "2022-03-20T19:02:13.531Z",
			"updated_at": "2022-03-20T19:02:13.531Z"
		},
		{
			"id": 3,
			"name": "Tether",
			"symbol": "usdt",
			"current_price": 1.001,
			"created_at": "2022-03-20T19:02:13.534Z",
			"updated_at": "2022-03-20T19:02:13.534Z"
		}
	],
	"current_page": 1,
	"total_pages": 1,
	"success": "true"
}






ALERT:

    POST:  /alerts
    {
        "alert":{
            "target_price": 3000,
            "coin_id": 2
        }
        
    }

    GET:  /alerts
        query_params: {page: 1}
                    {status: 'triggered','created','cancelled'}

    DELETE: /alerts/id
