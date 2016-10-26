namespace :app do

  desc 'Reset App for dev'
  task reset: :environment do
    Rake::Task['tmp:clear'].execute
    Rake::Task['log:clear'].execute
    Rake::Task['postgres:destroy_sessions'].execute
    Rake::Task['tmp:create'].execute
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    # Rake::Task['demo:seed'].execute
  end

end
