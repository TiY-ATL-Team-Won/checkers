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
  	self.turn_count = 1
  	binding.pry
  	self.save
  end

  def self.waiting
  	Game.where(:players_count => 1)
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
    json_return = {:board => board, :message_type => message_type, :message => message}
  end

  def test_move(params)
    start_x = params[x]
    start_y = params[y]
    type = self.board[start_x][start_y]

  	if current_user == game.players.first
  	  case type
  	  when 1
  	    test_red_move(start_x, start_y, params[move])
  	  when 2
  		  return_board(self.board, message_type = 0, message = "That's not your piece")
  	  when 3
  		  test_king_move(start_x, start_y, params[move])
      when 4
  		  return_board(self.board, message_type = 0, message = "That's not your piece")
  	  end
  	end
  end

  def test_red_move(st_x, st_y, moves)
  	moves.each do |move|
  	  mv_x = move[x]
  	  mv_y = move[y]
  	  if mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && self.board[mv_x][mv_y] == 0
  	  	self.board[st_x][st_y] = 0
  	  	self.board[mv_x][mv_y] = 1
  	  	return_hash = return_board(self.board, message_type = 1, message = "Move successful")
  	  else
  	  	return_hash = return_board(board, message_type = 0, message = "You can't move there!")
  	  end
  	end
    return_hash
  end

  def player_move(params)
  	start_x = params[x]
  	start_y = params[y]


  	if current_user == game.players.first
  		case type
  		when 1
  			red_move(start_x, start_y, params[move])
  		when 2
  			return_board(board, message_type = 0, message = "That's not your piece")
  		when 3
  			king_move(start_x, start_y, params[move])
  		when 4
  			return_board(board, message_type = 0, message = "That's not your piece")
  		end
  	else
  		case type
  		when 1
  			as_json(self.board)
  		when 2
  			black_move(start_x, start_y, params[move])
  		when 3
  			king_move(start_x, start_y, params[move])
  		when 4
  			king_move(start_x, start_y, params[move])
  		end
    end
  	
  	return_board(board, message_type, message)

  end



  def red_move(st_x, st_y, move)

  	moves.each do |move|
  	  mv_x = move[x]
  	  mv_y = move[y]
  	  if mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && board[mv_x][mv_y] == 0
  	  	self.board[st_x][st_y] = 0
  	  	self.board[mv_x][mv_y] = 1
  	  elsif mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && board[mv_x][mv_y] == 0
  	  	

  	  	#this code needs to be finished!



  	  end


  	end

  end


  def as_json(opts={})
  	super(:only =>[:board, :response_type, :response_content])
  end







end
