class Ability
  include CanCan::Ability

  def initialize(player)
    define_aliases

    player ||= Player.new

    apply_player_rights(player)
  end

  protected

  def define_aliases
    alias_action :create, :read, :update, :destroy, to: :crud
  end

  def apply_player_rights(player)
    player_id = player.id

    can :manage, [Player], id: player_id
    can :manage, [Game] do |game|
      Game.by_player(player)
    end

    # can :manage, [Player, Round, Setting], game_id: player.game_ids
    can :manage, [Round, Setting], game_id: player.game_ids
  end

end