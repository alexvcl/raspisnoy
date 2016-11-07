class GamesController < LoggedPlayerController

  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    @game = Game.create(game_params)
    respond_with @game, location: -> { game_wizard_index_path(@game, :players) }
  end

  def start
    @game.start_first_round
    redirect_to(game_path(@game))
  end

  private

    def game_params
      params.fetch(:game, {}).permit(
        :email,
        :description
      )
    end

end
