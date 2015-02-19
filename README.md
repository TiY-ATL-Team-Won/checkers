

Readme updated as of 2/18 at 11:26 AM

API Information
# Games Routes

* Joining a new game:
	
	`POST '/games'`
	- This route will create a game if there is no player 1 waiting in another game, but will join a game if a 		there is a player 1 waiting in an already created game.  This method is located in `app/controllers/games`

* Showing a game:
	
	`GET '/games/:id'`
	- The route will show a game. If you would like to look at a representation of the board in ruby, go to 		`app/models/game` and it is located in the `STARTING_BOARD` constant located at the top of the page

* Games index:
	
	`GET '/games'`
	- Shows all games in the system.  May not need this route eventually, but used it for testing purposes. Could 	also be helpful if we come to an agreement that we would eventually want a user to be able to choose a game 
	of his/her choice.  More to come.


# Users Routes 

* Registers new user:

	`POST '/users'`

* Login user:
	
	`POST '/users/sign_in'`


Both routes uses the same parameters and produces the same JSON below:

* Parameters: Datatype
  - email: string (required)
  - password: string (required)

* JSON returns
	- email
	- authentication_token

* Response

	`{"user":{"email":"rails@awesome.com","authentication_token":"dQU52Nzarq16sYE2DGxC"}}`


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
