class UsersController < ApplicationController

  def leaderboard
  	@users = User.all.sort_by(:experience)
  	render json: {:users => @users}, status: :ok
    @users = User.all.order(experience: :desc).first(25)
    render json: { :users => @users }, status: :created
  end


  private
    def as_json(opts={})
      super(:only => [:id, :email])
    end


end
