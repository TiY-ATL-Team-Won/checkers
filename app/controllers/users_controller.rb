class UsersController < ApplicationController

  def leaderboard
    @users = User.all.order(experience: :desc).first(25)
    render json: { :users => @users }, status: :created
  end

end
