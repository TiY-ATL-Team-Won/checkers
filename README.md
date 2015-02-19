

Readme updated as of 2/18 at 11:26 AM

API Information

USERS -
Join/Create a new game:
POST '/games'

JSON Response:
{"authentication_token":[{"email":"rachel@awesome.com","authentication_token":"UTxkHqFwC2_Tcz7_Ad-K"},{"email":"rails@awesome.com","authentication_token":"dQU52Nzarq16sYE2DGxC"},{"email":"rapture@awesome.com","authentication_token":"Se5nkpmnsPhHxyfxaTAu"},{"email":"blah@awesome.com","authentication_token":"2sUiybkjyaCjcAwx2QzD"},{"email":"blah@blah.com","authentication_token":"siyxDP98_kQR9Qhpw6zy"},{"email":"blahblah@blah.com","authentication_token":"nzu5z_8JwNonmHb6gLNi"}],"game":{"board":null,"turn_count":null}}

Show game:
GET '/games/:id'

Parameters: Datatype
 - auth_token: string (required)

JSON Response:
{"game":{"board":null,"turn_count":null},"player":{"email":"rails@awesome.com","authentication_token":"dQU52Nzarq16sYE2DGxC"}}

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
