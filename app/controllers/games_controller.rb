class GamesController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    @game = Game.find_by(params[:id])
    @player1 = @game.user.first
    @player2 = @game.user.second 
    render json: {:game => @game}, status: :ok
  end

  def move
  	move_info = JSON.parse(params.body)
  	@game.player_move()
  end

  def join
    @waiting = Game.waiting.first
    if @waiting
      @waiting.users << current_user
      redirect_to games_show_path(@waiting)
    else
      @game = Game.create
      @game.users = [current_user]
      @game.new_game! #intial board and turn count stuff...
      redirect_to games_show_path(@game)
    end
  end
end
