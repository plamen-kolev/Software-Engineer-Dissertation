namespace :faker do
  desc "TODO"
  task init: :environment do
    Rake::Task['db:purge'].invoke
    Rake::Task['db:migrate'].invoke
    User.create(:email => "local@host.com", :password => 'password', :password_confirmation => 'password')
    User.create(:email => "user2@host.com", :password => 'password', :password_confirmation => 'password')

    # associate machines with users
    (1..10).each do |n|
      Machine.create(title: "#{Faker::Hacker.verb}_#{Faker::Hacker.verb}_#{Faker::Hacker.verb}", user_id:1)
      Machine.create(title: "#{Faker::Hacker.verb}_#{Faker::Hacker.verb}_#{Faker::Hacker.verb}", user_id:2)
    end
  end

end
