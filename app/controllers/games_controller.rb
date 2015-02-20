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
    render json: game_response(@game), status: :ok
  end

  def join
    @waiting = Game.waiting.first
    if @waiting
      @waiting.users << current_user
      render json: game_response(@waiting), status: :ok
    else
      @game = Game.create
      @game.users = [current_user]
      @game.new_game!
      render json: game_response(@game), status: :created
    end
  end

  private

    def game_response(game)
      { :game => game.as_json(include: { users: { :only => [:id, :email]}})}
    end


end
