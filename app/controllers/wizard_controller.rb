class WizardController < LoggedUserController
  include Wicked::Wizard

  skip_load_and_authorize_resource

  steps :players, :points_settings #todo special_rules

  def show
    @game = Game.find(params[:game_id])

    case step
      when :players

      when :points_settings
        @settings = @game.setting
    end
    render_wizard
  end

  def update
    @game = Game.find(params[:game_id])

    case step
      when :players
        @game.assign_attributes(game_params)
        render_wizard(@game)
      when :points_settings
        @settings = @game.setting
        @settings.assign_attributes(setting_params)

        @game.setup_done!

        render_wizard(@settings)
    end
  end

  def finish_wizard_path
    game_path(Game.find(params[:game_id]))
  end

  private

    def game_params
      params.fetch(:game, {}).permit(
        player_ids: []
      )
    end

    def setting_params
      params.fetch(:setting, {}).permit(
        :common,
        :trumpless,
        :dark,
        :minimality,
        :golden,
        :fold_reward,
        :over_defence_reward,
        :shortage_penalty,
        :dark_penalty
      )
    end

end
