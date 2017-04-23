namespace :demo do

  desc 'Create Demo Data'
  task seed: :environment do

    puts '===================================Start Demo==================================='

    user = User.create(email: 'valet@valet.valet', password: '123123')

    ['Memas', 'Vasya', 'Petya', 'Walet'].each {|name| Player.create(name: name, user: user)}

    puts '===================================End Factories=============================='

  end

end