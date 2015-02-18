class Game < ActiveRecord::Base
  serialize :board

  def as_json(opts={})
    super(:only => [:board, :turn_count])
  end
end
