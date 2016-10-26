class GamesController < LoggedUserController

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    respond_with @game, location: -> { game_wizard_index_path(@game, :players) }
  end

  private

    def game_params
      params.fetch(:game, {}).permit(
        :email,
        :description
      )
    end

end
