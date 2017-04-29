namespace :demo do

  desc 'Create Demo Data'
  task seed: :environment do

    puts '===================================Start Demo==================================='

    user = User.create(name: 'Valet', email: 'valet@valet.valet', password: '123123')

    ['Memas', 'Vasya', 'Petya', 'Walet'].each {|name| Player.create(name: name, user: user)}

    puts '===================================End Factories=============================='

  end

  desc 'Randomly finish game'
  task :game_finish, [:game_id] => [:environment] do |t, args|
    game = Game.find(game_id)

    game.round.each do |round|
      next if round.tricks_counted?



      if round.in_progress?
        round.players.each do |p|
          to_order = (0..round.cards_served).to_a.sample
          round.bids.create(player: p, ordered: to_order) unless round.bids.prensent?
        end

      elsif round.betting?
        round.players.each do |p|

        end
      end

    end
  end

end