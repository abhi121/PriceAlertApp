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

use rails db:seed command to generate coins data 

COINS:     
     GET: /coins






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
