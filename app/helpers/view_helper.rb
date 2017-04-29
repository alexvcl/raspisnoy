module ViewHelper

  def primary_button(f, name = 'Submit', options = {})
    default_options = {type: 'submit', class: 'btn btn-sm btn-default'}
    f.button(:submit, name, default_options.deep_merge(options))
  end

  def alert_message(message)
    return '' unless message
    if message.kind_of?(Array)
      message.join(';')
    elsif message.kind_of?(String)
      message
    else
      message.to_s
    end
  end

  def game_continue_setup(game)
    step = game.players.present? ? :points_settings : :players
    link_to('Continue setup', game_wizard_path(game, step), class: 'btn btn-info')
  end

  def round_format_letter(round)
    if round.common?
      round.cards_served
    else
      round.format_type[0].upcase
    end
  end

  def format_colored(round)
    color = case round.format_type
    when 'common'
      'primary'
    when 'trumpless'
      'success'
    when 'dark'
      'dark'
    when 'minimality'
      'danger'
    when 'golden'
      'warning'
    end

    content_tag(:span, round.translate_enum(:format_type), class: "badge bg-#{color}")
  end

  def trump_decorated(round)
    trump_color = (round.trump == '♥ heart' or round.trump == '♦ diamond') ? 'text-red' : ''
    safe_join([content_tag(:span, class: trump_color) { round.trump.split.first }, round.trump.split.last], ' ')
  end

  def cards_server_decorated(round)
    content_tag(:span, round.cards_served, class: 'badge bg-info text-black')
  end

  def players_bid(round, bid)
    bg_color = bid.dark ? 'bg-dark' : 'bg-primary'
    content_tag(:span, round.tricks_counted? ? [bid.trick, bid.ordered].join('/') : bid.ordered,
                class: "badge #{bg_color}") #.text-black
  end

  def show_winner(game)
    winner = game.who_is_the_winner
    return unless winner

    ['Winner:', [winner.name, 'with', game.score_by(winner), 'points'].join(' ')]
    # content_tag(:h3) do
    #   safe_join(['Winner:', [winner.name, 'with', game.score_by(winner), 'points'].join(' ')], ' ')
    # end
  end

end