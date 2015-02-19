class GamesController < ApplicationController
  before_action :authenticate_user_from_token!

  def index
    @games = Game.all
    render json: {:game => @games}, status: :ok
  end

  def show
    @game = Game.find(params[:id])
    @player1 = @game.users.first
    @player2 = @game.users.second
    render json: {:game => @game, :users => {:player1 => @player1, :player2 => @player2}}, status: :ok
  end

  def join
    @waiting = Game.waiting.first
    if @waiting
      @waiting.users << current_user
      render json: {:users => @waiting.users, :game => @waiting}
    else
      @game = Game.create
      @game.users = [current_user]
      @game.new_game!
      render json: {:users => @game.users, :game => @game}
    end
  end

  private
  def game_response(game)
    {:users => game.as_json(include: {users: {:only => [:id, :email] }})}
  end
end
