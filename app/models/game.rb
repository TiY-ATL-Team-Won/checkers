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
  	self.save
  end

  def self.waiting
  	Game.where(:players_count => 1)
  end

  def self.active
  	Game.where(:finished => false)
  end

  def game_opponent_pieces
    self.turn_count.odd? == true ? [2,4] : [1,3]
  end

  def game_current_player_pieces
    self.turn_count.odd? == true ? [2,4] : [1,3]
  end

  def on_board?(move)
    x,y = move
    return false unless x>=0 && x<=7 && y>=0 && y<=7
    true
  end

  def is_jump_available?
    self.board.each do |r|
      row.each do |c|
        #check if jumps avaiable for each piece
        if game_current_player_pieces.include?(self.board[row][col])
          piece = self.board[r][c]
          case piece
          when 1
            return true if down_double?([[r,c],[r+2,c-2]])||down_double?([[r,c],[r+2,c+2]])
          when 2
            return true if up_double?([[r,c],[r-2,c+2]])||up_double?([[r,c],[r-2,c-2]])
          when 3
            return true if up_double?([[r,c],[r-2,c+2]])||up_double?([[r,c],[r-2,c-2]]) ||
            down_double?([[r,c],[r+2,c+2]])||down_double?([[r,c],[r+2,c-2]])
          when 4
            return true if up_double?([[r,c],[r-2,c+2]])||up_double?([[r,c],[r-2,c-2]]) ||
            down_double?([[r,c],[r+2,c+2]])||down_double?([[r,c],[r+2,c-2]])
          end
        else
          return false
        end
      end
    end
  end

  def up_double?(moves)
    x1,y1 = moves.first
    x3,y3 = moves[1]
    x2, y2 = x3 > x1 ? (x1+1) : (x1-1), y1-1
    if on_board?(moves[1]) && self.game_opponent_pieces.include?(game.board[x2][y2])
      return false unless ((x1-x3).abs == 2) && (y1-y3 == 2)
    end
    true
  end

  def down_double?(moves)
    x1,y1 = moves.first
    x3,y3 = moves[1]
    x2,y2 = x3 > x1 ? (x1+1) : (x1-1), y1 + 1
    if on_board?(moves[1]) && self.game_opponent_pieces.include?(game.board[x2][y2])
      return false unless ((x1-x3).abs == 2) && (y3-y1 == 2)
    end
    true
  end

  def is_jump?(moves)
    x,y = moves.first
    ([2,3,4].include?(self.board[x][y]) && (up_double?(moves)) ||
    ([1,3,4].include?(self.board[x][y]) && (down_double?(moves))
  end

  def any_jumps_left?(moves)
    #x,y = moves.last

  end

  def valid_multi_jump?(moves)
    return false unless (moves.all? {|x| self.is_jump?(x)} && !any_jumps_left(moves))
    true
  end

  def valid_move?(moves)
     return false unless moves.all? {|x| self.on_board?(x)}
     return false unless moves.any? {|x| self.already_taken?(x)}
     return false unless is_jump_available? && !is_jump(moves)
  #   if moves.length > 2
  #     valid_multi_jump?(move,user)
  #     are there other jumps?
  #   elsif up_double? (move, user)
  #     are there other jumps
  #   elsif up_single?(move, user)
  #   else
  #     error
  #   end
  end

  def already_taken?(move, by = nil)
    x,y = move
    if by && by.include?(self.board[x][y])
      return true
    else
      !self.board[x][y].zero?
    end
  end

  def up_single?(moves)
    x1,y1 = moves.first
    x2,y2 = moves[1]
    return false unless ((x1-x2).abs == 1) && (y1-y2 == 1)
    true
  end

  def down_single?(moves)
    x1,y1 = moves.first
    x2,y2 = moves[1]
    return false unless ((x1-x2).abs == 1) && (y2-y1 == 1)
    true
  end
end
