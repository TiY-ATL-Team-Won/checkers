class GamesController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    @game = Game.find_by(params[:id])
    @player1 = @game.user.first
    @player2 = @game.user.second 
    render json: {:game => @game}, status: :ok
  end

  def move
  	@game = Game.find_by(params[:id])
  	move_info = JSON.parse(params.body)
  	return_info = @game.player_move(move_info)
  	render json: {:game => @game}, status: :ok
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


  private

  def as_json(opts={})
  	super(:only =>[:board, :response_type, :response_content])
  end
end
