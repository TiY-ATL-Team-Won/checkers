class GamesController < ApplicationController
  before_action :authenticate_user_from_token!

  def show
    @game = Game.find_by(params[:id])
    @player1 = @game.users.first
    @player2 = @game.users.second
    #render json: {:game => @game, :player => {:user_id => @player1, :user_id => @player2}}, status: :ok
    render json: {:game => @game, :users => {:player1 => @player1, :player2 => @player2}}, status: :ok
    # render json: {:game => @game, :player => @player1, :player => @player2}
    #render json: {:game => @game.users}
    #think abt what devs need. prob player 2 and 1
  end

  def join
    @waiting = Game.waiting.first
    if @waiting
      @waiting.users << current_user
      render json: {:authentication_token => @waiting.users, :game => @waiting}
    #  redirect_to games_show_path(@waiting)
    else
      @game = Game.create
      @game.users = [current_user]
      @game.new_game! #intial board and turn count stuff... thats what front end is rendering?
    #  redirect_to games_show_path(@game)
      render json: {:authentication_token => @game.users, :game => @game}
    end
  end

end
