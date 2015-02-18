class GamesController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    @game = Game.find_by(params[:id])
    render json: {:game => @game}, status: :ok
  end
end
