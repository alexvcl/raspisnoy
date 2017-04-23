class PlayersController < LoggedUserController

  # def create
  #
  # end

  # def edit
  #
  # end

  private

    def player_params
      params.fetch(:player, {}).permit(
        :name
      )
    end

end
