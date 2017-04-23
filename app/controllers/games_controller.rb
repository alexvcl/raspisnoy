class GamesController < LoggedUserController

  def new
    @game = Game.new
  end

  def create
    @game = current_user.games.create(game_params)
    respond_with @game, location: -> { game_wizard_index_path(@game, :players) }
  end

  def start
    @game.start!
    redirect_to(game_round_path(@game, @game.current_round))
  end

  def current_round
    redirect_to game_round_path(@game, @game.current_round)
  end

  private

    def game_params
      params.fetch(:game, {}).permit(
        :email,
        :description
      )
    end

end
