class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players 
  validates_length_of :users, maximum: 2
  validates :users, uniqueness: true, scope: :game_id

  serialize :board

  def as_json(opts={})
    super(:only => [:board, :turn_count])
  end
end
