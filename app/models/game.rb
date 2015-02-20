class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players
  validates_length_of :users, maximum: 2


  serialize :board

  def as_json(opts={})
    options = { :only => [:board, :turn_count] }
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



end
