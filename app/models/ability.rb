class Ability
  include CanCan::Ability

  def initialize(user)
    define_aliases

    user ||= User.new

    apply_user_rights(user)
  end

  protected

  def define_aliases
    alias_action :create, :read, :update, :destroy, to: :crud
  end

  def apply_user_rights(user)
    user_id = user.id

    can :manage, [User], id: user_id
    can :manage, [Player], user_id: user_id
    can :manage, [Game], user_id: user_id
    # can :manage, [Game] do |game| #todo sql query reflection
    #   Game.by_player(user)
    # end

    can :manage, [Setting], game_id: user.game_ids

    # ================================

    round_rights(user)
  end

  def round_rights(user)
    can :show, [Round], game_id: user.game_ids
    can [:set_orders, :betting], [Round], status: Round.statuses['betting'], game_id: user.game_ids

    can [:set_tricks, :proceed_scores], [Round], status: Round.statuses['in_progress'], game_id: user.game_ids
    can [:set_tricks, :proceed_scores], [Round], format_type: [Round.format_types['minimality'], Round.format_types['golden']], game_id: user.game_ids

    cannot [:betting, :proceed_scores, :set_orders, :set_tricks], [Round], status: Round.statuses['tricks_counted']
    cannot [:set_orders, :betting], [Round], format_type: [Round.format_types['minimality'], Round.format_types['golden']]
  end

end