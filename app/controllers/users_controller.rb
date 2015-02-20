class UsersController < ApplicationController

<<<<<<< HEAD
=======
  # def as_json(opts={})
  #   super(:only => [:id, :email])
  # end

  def leaderboard
    @users = User.all.order(experience: :desc).first(25)
    render json: { :users => @users }, status: :created
  end
>>>>>>> c77c4e612c0b943cd227ed6a8b68f0450df34027

end
