

Readme updated as of 2/18 at 11:26 AM

API Information

USERS -

Registers new user:

POST '/users'

Login user:
POST '/users/sign_in'

Both routes uses the same parameters and produces the same JSON below:

* Parameters: Datatype
  - email: string (required)
  - password: string (required)

* JSON returns
	- email
	- authentication_token

Response
{"user":{"email":"rails@awesome.com","authentication_token":"dQU52Nzarq16sYE2DGxC"}}


BACKEND Info

* Ruby version

	- 2.1.5

* System dependencies

* Configuration

	- Devise gem required for Users

* Database Schema

	* Users
		- email = string
		- password = string
		- authentication_token = string

	* Games

		- player1_email = string
		- player2_email = string
		- board = text
		- turn_count = integer
		- finished = boolean
		- players_count = integer

	- Players (Join Table between Users/Games)

		- user_id = integer
		- game_id = integer


* Database initialization

	- git clone
	- 'bundle install' inside project directory
	- run 'rake db:migrate' to initialize database on local machine

	TO LOOK AT ROUTES:

		- run 'rake routes | less' in terminal while inside the project directory


* Deployment instructions

	- simply go to localhost:3000 to begin
