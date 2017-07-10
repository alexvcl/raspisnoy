class DealerService

  def self.game_winner(game)

  end

  # def who_is_the_winner
  #   return unless rounds_complete?
  #   scores = {}
  #
  #   # Round.where(game_id: Game.first.id).joins(:scores).select('SUM(scores.points) as player_score')
  #   #     .group('scores.player_id').where('GREATEST(scores.player_score)')
  #   puts '============='
  #   puts players.joins([:scores, :rounds]).where(rounds: {game_id: game.id}).select('SUM(scores.points)')
  #   puts '============='
  #
  #   players.each do |player|
  #     scores[player] = score_by(player)
  #   end
  #   scores.key(scores.values.max)
  # end

end