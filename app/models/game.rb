class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players
  serialize :board

  def as_json(opts={})
    super(:only => [:board, :turn_count])
  end
end
