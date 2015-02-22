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
    #self.users.first
    #self.players_count = 1
  	self.turn_count = 1

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
    @game = Game.find(params["id"].to_i)
    user_id = params["user_id"]
    start_x = params["x"]
    start_y = params["y"]
    current_user = User.find(user_id)
    type = @game.board[start_y][start_x]

  	if ((type == 1 || type == 3) && current_user = @game.players.first) || ((type == 2 || type == 4) && current_user = @game.players.second)
  	  case type
  	  when 1
  	    test = test_black_move(start_x, start_y, type, params["move"])
  	  when 2
  		  test = test_red_move(start_x, start_y, type, params["move"])
  	  when 3
  		  test = test_king_move(start_x, start_y, type, params["move"])
      when 4
  		  test = test_king_move(start_x, start_y, type, params["move"])
  	  end
  	end
    test
  end

  # this is a misnormer, this code is not test code any more
  # 
  def test_black_move(st_x, st_y, type, moves)
  	moves.each do |move|
  	  mv_x, mv_y = move
  	  if legal_black_move(st_x, st_y, mv_x, mv_y, @game.board)
  	  	@game.board[st_y][st_x] = 0
  	  	@game.board[mv_y][mv_x] = 1
        if king_me(mv_x, mv_y, type)
          @game.turn_count = 2
          @game.save
          return {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful, you now have a king!"}
        end
  	  else
  	  	return {:board => @game.board, :turn_count => @game.turn_count, :message_type => 0, :message => "Move unsuccessful"}
  	  end
  	end
    @game.turn_count = 2
    @game.save
    {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful"}
  end

  # this is a misnomer, this code is not test code any more
  def test_red_move(st_x, st_y, type, moves)
    moves.each do |move|
      mv_x, mv_y = move
      if legal_red_move(st_x, st_y, mv_x, mv_y, @game.board)
        @game.board[st_y][st_x] = 0
        @game.board[mv_y][mv_x] = 2
        if king_me(mv_x, mv_y, type)
          @game.turn_count = 1
          @game.save
          return {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful, you now have a king!"}
        end
      else
        return {:board => @game.board, :message_type => 0, :message => "Move unsuccessful"}
      end
    end
    @game.turn_count = 1
    @game.save
    {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful"}
  end


  def test_king_move(st_x, st_y, type, moves)
    moves.each do |move|
      mv_x, mv_y = move
      if legal_king_move(st_x, st_y, mv_x, mv_y, @game.board)
        @game.board[st_y][st_x] = 0
        @game.board[mv_y][mv_x] = type
        if type == 3
          @game.turn_count = 2
        elsif type == 4
          @game.turn_count = 1
        end
      else
        return {:board => @game.board, :message_type => 0, :message => "Move unsuccessful"}
      end
    end
    @game.save
    {:board => @game.board, :turn_count => @game.turn_count, :message_type => 1, :message => "Move successful"}
  end






  # checks red moves for legality (single move, does not check for jumps)
  def legal_red_move(start_x, start_y, x, y, board)
    y + 1 == start_y && (x - 1 == start_x || x + 1 == start_x) && board[y][x] == 0
  end

  # checks black moves for legality (single move, does not check for jumps)
  def legal_black_move(start_x, start_y, x, y, board)
    y - 1 == start_y && (x - 1 == start_x || x + 1 == start_x) && board[y][x] == 0
  end

  def legal_king_move(start_x, start_y, x, y, board)
    (y - 1 == start_y || y + 1 == start_y) && (x - 1 == start_x || x + 1 == start_x) && board[y][x] == 0
  end

  # checks to see if a piece should be kinged at the end of a turn, it it should be, king it!
  def king_me(mv_x, mv_y, type)
    if type == 1 && mv_y == 7
      @board[mv_y][mv_x] = 3
      return true
    elsif type == 2 && mv_y == 0
      @board[mv_y][mv_x] = 4
      return true
    else
      return false
    end
  end



end
