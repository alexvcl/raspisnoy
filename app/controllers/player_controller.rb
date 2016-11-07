class PlayersController < LoggedPlayerController

  def edit

  end

  private

    def player_params
      params.fetch(:player, {}).permit(
        :email
      )
    end

end
