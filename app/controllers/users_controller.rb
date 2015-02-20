class UsersController < ApplicationController

  # def as_json(opts={})
  #   super(:only => [:id, :email])
  # end

  def leaderboard
    @users = User.all.order(experience: :desc).first(25)
    render json: { :users => @users }, status: :created
  end

end
