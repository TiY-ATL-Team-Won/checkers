class Player < ActiveRecord::Base
	belongs_to :user
	belongs_to :game

<<<<<<< HEAD
	validates_uniqueness_of :user_id, scope: :game_id
=======
  validates_uniqueness_of :user_id, scope: :game_id
>>>>>>> aef8e6bdc8c37732c1f03e5951335a01d892e04f
end
