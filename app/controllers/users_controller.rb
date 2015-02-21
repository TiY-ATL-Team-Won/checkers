class UsersController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    @user = current_user
    render json: { :user => @user }, status: :created
  end


  def leaderboard
    @users = User.order(experience: :desc).limit(25)
    render json: { :users => @users }, status: :created
  end
end

