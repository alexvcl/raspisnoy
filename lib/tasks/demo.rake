namespace :demo do

  desc 'Create Demo Data'
  task seed: :environment do

    puts '===================================Start Demo==================================='

    Player.create({
                  email: 'demo@gmail.com',
                  password: '123123',
                  name: 'Memas'
    })

    Player.create({
                      email: 'demo1@gmail.com',
                      password: '123123',
                      name: 'Vasya'
                  })

    Player.create({
                      email: 'demo2@gmail.com',
                      password: '123123',
                      name: 'Petya'
                  })

    puts '===================================End Factories=============================='

  end

end