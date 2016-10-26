class WizardController < LoggedUserController
  include Wicked::Wizard

  steps :players, :points_settings #todo special_rules

  def show
    case step
      when :players
        @players_batch = PlayersBatch.new
        6.times { @players_batch.players.build(game: @game) }
      when :points_settings

    end
    render_wizard
  end

  def update

  end

  # def finish_wizard_path
  #
  # end

  private

end
