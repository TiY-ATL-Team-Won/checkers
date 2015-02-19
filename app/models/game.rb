class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players
  validates_length_of :users, maximum: 2


  serialize :board

  def as_json(opts={})
    super(:only => [:board, :turn_count])
  end

  STARTING_BOARD = [[0, 1, 0, 1, 0, 1, 0, 1],
                    [1, 0, 1, 0, 1, 0, 1, 0],
 					[0, 1, 0, 1, 0, 1, 0, 1],
 					[0, 0, 0, 0, 0, 0, 0, 0],
 					[0, 0, 0, 0, 0, 0, 0, 0],
 					[2, 0, 2, 0, 2, 0, 2, 0],
 					[0, 2, 0, 2, 0, 2, 0, 2],
 					[2, 0, 2, 0, 2, 0, 2, 0]]

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


  def player_move(params)
  	start_x = params[x]
  	start_y = params[y]
  	case type
  	when 1
  		red_move(start_x, start_y, params[move])
  	when 2
  		black_move(start_x, start_y, params[move])
  	when 3
  		red_king_move(start_x, start_y, params[move])
  	when 4
  		black_king_move(start_x, start_y, params[move])
  	end
  	
  	as_json(move_info)
  end

  def red_move(st_x, st_y, move)
  	num_moves = move.size
  	num_moves.each do |move|
  	  mv_x = move[x]
  	  mv_y = move[y]
  	  if mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && board[mv_x][mv_y] == 0
  	  	board[mv_x][mv_y] = 1
  	  elsif mv_x - 1 == st_x && (mv_y - 1 == st_y || mv_y + 1 == st_y) && board[mv_x][mv_y] == 0


end
