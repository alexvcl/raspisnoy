module ViewHelper

  def primary_button(f, name = 'Save', options = {})
    default_options = {class: 'btn btn-success'}
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

  def round_format_letter(round)
    if round.common?
      round.cards_served
    else
      round.format_type[0].upcase
    end
  end

  def trump_colored(round)
    trump_color = (round.trump == '♥ heart' or round.trump == '♦ diamond') ? 'text-red' : ''
    safe_join([content_tag(:span, class: trump_color) { round.trump.split.first }, round.trump.split.last], ' ')
  end

end