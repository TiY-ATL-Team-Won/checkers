class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players
  validates_length_of :users, maximum: 2


  serialize :board

  def as_json(opts={})
    options = { :only => [:board, :turn_count, :id] }
    options.merge!(opts)
    super(options)
  end

  STARTING_BOARD = [[1, 0, 1, 0, 1, 0, 1, 0],
                    [0, 1, 0, 1, 0, 1, 0, 1],
                    [1, 0, 1, 0, 1, 0, 1, 0],
           					[0, 0, 0, 0, 0, 0, 0, 0],
           					[0, 0, 0, 0, 0, 0, 0, 0],
           					[0, 2, 0, 2, 0, 2, 0, 2],
           					[2, 0, 2, 0, 2, 0, 2, 0],
           					[0, 2, 0, 2, 0, 2, 0, 2]]


  def new_game!
  	self.board = STARTING_BOARD
    # self.update_attribute :board, STARTING_BOARD
    #binding.pry
    #self.users.first
    #self.players_count = 1
  	self.turn_count = 1
  	#binding.pry

  	self.save
  end

  def self.waiting
  	# Game.where(:players_count => 1)
    Game.joins(:users).where(players_count: 1)
  end

  def self.active
  	Game.where(:finished => false)
  end


#  params = { x => int, y => int, move => [[x1, y1], [x2, y2]]}
#
#
#
#

  def return_board(board, message_type, message)
    return {:board => board, :message_type => message_type, :message => message}
  end


  # set up a 'direction' variable that is based on player, that way we only need a player_move
  # this renders having a black and red_move function unnecessary

  def test_move(params)
    #binding.pry
    @game = Game.find(params["id"].to_i)
    user_id = params["user_id"]
    start_x = params["x"]
    start_y = params["y"]
    current_user = User.find(user_id)
    type = @game.board[start_y][start_x]
    #binding.pry

  	if ((type == 1 || type == 3) && current_user = @game.players.first) || ((type == 2 || type == 4) && current_user = @game.players.second)
  	  case type
  	  when 1
        #binding.pry
  	    test = test_black_move(start_x, start_y, params["move"])
  	  when 2
        #binding.pry
  		  test = test_red_move(start_x, start_y, params["move"])
  	  when 3
  		  test = test_king_move(start_x, start_y, params[move])
      when 4
  		  test = return_board(@game.board, message_type = 0, message = "That's not your piece")
  	  end
  	end
    test
  end

  def test_black_move(st_x, st_y, moves)
    #binding.pry
  	moves.each do |move|
  	  mv_x, mv_y = move
      #binding.pry
  	  if legal_black_move(st_x, st_y, mv_x, mv_y, @game.board)
  	  	@game.board[st_y][st_x] = 0
  	  	@game.board[mv_y][mv_x] = 1
  	  else
        #binding.pry
  	  	return {:board => @game.board, :message_type => 0, :message => "Move unsuccessful"}
  	  end
  	end
    @game.turn_count = 2
    @game.save
    {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful"}
  end

  def test_red_move(st_x, st_y, moves)
    #binding.pry
    moves.each do |move|
      mv_x, mv_y = move
      #binding.pry
      if legal_red_move(st_x, st_y, mv_x, mv_y, @game.board)
        #binding.pry
        @game.board[st_y][st_x] = 0
        @game.board[mv_y][mv_x] = 2
      else
        #binding.pry
        return {:board => @game.board, :message_type => 0, :message => "Move unsuccessful"}
      end
    end
    @game.turn_count = 1
    @game.save
    {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful"}
  end

  def legal_red_move(start_x, start_y, x, y, board)
    y + 1 == start_y && (x - 1 == start_x || x + 1 == start_x) && board[y][x] == 0
  end

  def legal_black_move(start_x, start_y, x, y, board)
    y - 1 == start_y && (x - 1 == start_x || x + 1 == start_x) && board[y][x] == 0
  end

  # def player_move(params)
  # 	start_x = params[x]
  # 	start_y = params[y]


  # 	if current_user == game.players.first
  # 		case type
  # 		when 1
  # 			red_move(start_x, start_y, params["move"])
  # 		when 2
  # 			return_board(board, message_type = 0, message = "That's not your piece")
  # 		when 3
  # 			king_move(start_x, start_y, params[move])
  # 		when 4
  # 			return_board(board, message_type = 0, message = "That's not your piece")
  # 		end
  # 	else
  # 		case type
  # 		when 1
  # 			as_json(self.board)
  # 		when 2
  # 			black_move(start_x, start_y, params[move])
  # 		when 3
  # 			king_move(start_x, start_y, params[move])
  # 		when 4
  # 			king_move(start_x, start_y, params[move])
  # 		end
  #   end

  # 	return_board(board, message_type, message)

  # end



  # def red_move(st_x, st_y, move)

  # 	moves.each do |move|
  # 	  mv_x = move[x]
  # 	  mv_y = move[y]
  # 	  if mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && board[mv_x][mv_y] == 0
  # 	  	self.board[st_x][st_y] = 0
  # 	  	self.board[mv_x][mv_y] = 1
  # 	  elsif mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && board[mv_x][mv_y] == 0


  # 	  	#this code needs to be finished!



  # 	  end


  # 	end

  # end

>>>>>>> origin/fix_counter_cache


end
