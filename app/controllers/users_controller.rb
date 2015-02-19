class UsersController < ActiveRecord::Base

  def leaderboard
  	@users = User.all.sort_by(:experience)
  	render json: {:users => @users}, status: :ok
  end


  private
    def as_json(opts={})
      super(:only => [:id, :email])
    end


end
