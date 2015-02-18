class GamesController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    @game = Game.find_by(params[:id])
    render json: {:game => @game}, status: :ok
  end

  def move
  	move_info = JSON.parse(params.body)
  	@game.player_move()
end
