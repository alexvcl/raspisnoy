class PlayersController < LoggedUserController

  # def create
  #
  # end

  def edit
    render(layout: false)
  end

  def update
    @player.update(player_params)
  end

  private

    def player_params
      params.fetch(:player, {}).permit(
        :name,
        :avatar,
        :remote_avatar_url
      )
    end

end
