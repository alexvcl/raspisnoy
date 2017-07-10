class RoundsController < LoggedUserController

  def show
    @game = @round.game
  end

  def betting
    @game = @round.game
    @game.players.each { |player| @round.bids.build(player: player) } unless @round.bids.any?
  end

  def set_orders
    @game = @round.game
    if @round.update(round_params)
    # if @round.save!(round_params)
      @round.in_progress!
      respond_with @round, location: -> { game_round_path(@game, @round) }
    else
      # redirect_to betting_game_round_path(@game, @round), alert: @round.errors.full_messages
      redirect_to betting_game_round_path(@game, @round), alert: @round.errors.messages.values
    end
  end

  def proceed_scores
    @game = @round.game
  end

  def set_tricks
    @game = @round.game
    if @round.update(round_params)
    # if @round.save!(round_params)
      @round.tricks_counted!
      @round.game.next_round!
      @round.add_scores!
      respond_with @round, location: -> { game_round_path(@game, @game.current_round) }
    else
      redirect_to proceed_scores_game_round_path(@round.game, @round), alert: @round.errors.full_messages
    end
  end

  private

    def round_params
      params.fetch(:round, {}).permit(
        :trump,
        jokers: [],
        bids_attributes: [:ordered, :trick, :dark, :dark_penalty, :id, :player_id]
      )
    end

end
