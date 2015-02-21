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

  def up_single?(moves)
    x1,y1 = moves.first
    x2,y2 = moves[1]
    return false unless ((x1-x2).abs == 1) && (y1-y2 == 1)
  end

  def down_single?(moves)
    x1,y1 = moves.first
    x2,y2 = moves[1]
    return false unless ((x1-x2).abs == 1) && (y2-y1 == 1)
  end

  def up_double?(moves)
    x1,y1 = moves.first
    x2,y2 = moves[1]
    return false unless ((x1-x2).abs == 2) && (y1-y2 == 2)
  end

  def down_double(moves)
    x1,y1 = moves.first
    x2,y2 = moves[1]
    return false unless ((x1-x2).abs == 2) && (y2-y1 == 2)
  end

end
